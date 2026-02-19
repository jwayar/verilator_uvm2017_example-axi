#!/usr/bin/env bash
set -euo pipefail

# simulate_verilator.sh - script that runs inside the docker container.
# This script always sources config.sh from its own directory
# Outputs:
#   Artifacts on $ARTIFACTS_DIR (config.sh defines it)
# Exit codes:
#   3 = config.sh not found
#   4 = file in MANUAL_FILE_ORDER not found
#   5 = verilator build failed
#   6 = make failed
#   7 = verilator binary not found
#   8 = simulation failed
#  10 = invalid UVM_TESTNAME
# Usage:
#  ./simulate_verilator.sh

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_PATH="${SCRIPT_DIR}/config.sh"

if [ ! -f "$CONFIG_PATH" ]; then
    echo "ERROR: config.sh not found at $CONFIG_PATH"
    exit 3
fi

# shellcheck source=/dev/null
source "$CONFIG_PATH"

echo "=== simulate_verilator.sh ==="
echo "Script directory: $SCRIPT_DIR"
echo "Project root: $PROJECT_ROOT"
echo "Top module: $TOP_MODULE"
echo "UVM testname: $UVM_TESTNAME"

mkdir -p "$ARTIFACTS_DIR"
chmod a+rwX "$ARTIFACTS_DIR"

# Validate UVM test
if [[ ! " ${AVAILABLE_TESTS[*]} " =~ " ${UVM_TESTNAME} " ]]; then
    echo "ERROR: Test \"$UVM_TESTNAME\" is not listed in AVAILABLE_TESTS."
    echo "Available tests:"
    printf "  - %s\n" "${AVAILABLE_TESTS[@]}"
    exit 10
fi

#############################################
#   FILELIST GENERATION (NO HARDCODEADO)
#############################################
make_incdirs_from_find() {
    find "$RTL_DIR" "$SIM_DIR" "$VIP_DIR" -type f \
        \( -name "*.sv" -o -name "*.svh" -o -name "*.vh" \) \
        -printf '%h\n' | sort -u
}

#############################################
#   UVM PACKAGE
#############################################
UVM_PKG_SV=""
if [ -n "${UVM_HOME:-}" ] && [ -f "$UVM_HOME/uvm_pkg.sv" ]; then
    UVM_PKG_SV="$UVM_HOME/uvm_pkg.sv"
    echo "Using uvm_pkg.sv at: $UVM_PKG_SV"
fi

#############################################
#   VERILATOR CMD BUILD
#############################################
BUILD_LOG="$ARTIFACTS_DIR/verilator_build.log"
EXEC_LOG="$ARTIFACTS_DIR/verilator_exec.log"

VERILATOR_BUILD_ABS_PATH="${SCRIPT_DIR}/${VERILATOR_BUILD_DIR}"
mkdir -p "$VERILATOR_BUILD_ABS_PATH"
# ----------------------------------------

echo "--- Running Verilator (logs in $BUILD_LOG) ---"
START_VERILATOR_TS=$(date +%s) # METRICA: Inicio de generación C++
set -x

CMD_BASE=(verilator)

# Flags pueden tener múltiples tokens
# Flags of verilator
read -r -a VF_ARRAY <<< "$VERILATOR_FLAGS"
CMD_BASE+=("${VF_ARRAY[@]}")

CMD_BASE+=(--top-module "$TOP_MODULE")

# --- FIX CRÍTICO: Añadir -Mdir con ruta absoluta ---
# Esto garantiza que make y el binario sepan dónde buscar los archivos.
CMD_BASE+=(-Mdir "$VERILATOR_BUILD_ABS_PATH")

# incdirs UVM + project root
if [ -n "${UVM_HOME:-}" ]; then
    CMD_BASE+=("+incdir+$UVM_HOME")
fi
CMD_BASE+=("+incdir+$PROJECT_ROOT")

# --- incdirs automáticas de RTL/SIM ---
INC_DIRS=()
mapfile -t INC_DIRS < <(make_incdirs_from_find)
for d in "${INC_DIRS[@]}"; do
    CMD_BASE+=("+incdir+$d")
done

# defines extra
if [ -n "${VERILATOR_EXTRA_DEFINES:-}" ]; then
    read -r -a DEF_ARRAY <<< "$VERILATOR_EXTRA_DEFINES"
    CMD_BASE+=("${DEF_ARRAY[@]}")
fi

# uvm_pkg
if [ -n "$UVM_PKG_SV" ]; then
    CMD_BASE+=("$UVM_PKG_SV")
fi

#############################################
#   BUILD FINAL FILELIST
#############################################

FILES=()

echo "--- Adding explicitly ordered files from config.sh ---"
for f in "${MANUAL_FILE_ORDER[@]}"; do
    if [[ -f "$f" ]]; then
        FILES+=("$f")
    else
        echo "ERROR: Missing file in MANUAL_FILE_ORDER: $f"
        exit 4
    fi
done

echo "=== Final filelist (${#FILES[@]} files) ==="

# Add to CMD
for f in "${FILES[@]}"; do
    CMD_BASE+=("$f")
done


# run verilator (C++ code generation)
"${CMD_BASE[@]}" > "$BUILD_LOG" 2>&1 || {
    echo "Verilator failed. Tail of build log:"
    tail -n 100 "$BUILD_LOG"
    exit 5
}
END_VERILATOR_TS=$(date +%s) # METRICA: Fin de generación C++
VERILATOR_ELAPSED=$((END_VERILATOR_TS - START_VERILATOR_TS))
echo "Verilator C++ Generation Time: ${VERILATOR_ELAPSED}s"

#############################################
#   MAKE + SIMULATION
#############################################
# FIX: Usar la ruta ABSOLUTA para Make y el binario
BIN="${VERILATOR_BUILD_ABS_PATH}/V${TOP_MODULE}"

# --- 1. Make (C++ Compilation/Linking) ---
echo "--- Starting C++ Compilation (Make) ---"
START_MAKE_TS=$(date +%s) # METRICA: Inicio de Make

# FIX: Forzar la ejecución de Make
(
    cd "$VERILATOR_BUILD_ABS_PATH" &&
    make -j "$MAKE_JOBS" -f V${TOP_MODULE}.mk
) >> "$BUILD_LOG" 2>&1 || {
    echo "Make failed. Tail of build log:"
    tail -n 100 "$BUILD_LOG"
    exit 6
}

if [ ! -x "$BIN" ]; then
    echo "ERROR: Verilator binary not found: $BIN"
    ls -la "$VERILATOR_BUILD_ABS_PATH" || true
    exit 7
fi
END_MAKE_TS=$(date +%s) # METRICA: Fin de Make
MAKE_ELAPSED=$((END_MAKE_TS - START_MAKE_TS))
echo "C++ Compilation Time: ${MAKE_ELAPSED}s"


# --- 2. Simulation Execution ---
echo "Executing: $BIN +UVM_TESTNAME=\"$UVM_TESTNAME\""
START_EXEC_TS=$(date +%s)
mkdir -p "logs"

"$BIN" +UVM_TESTNAME="$UVM_TESTNAME" \
       +verilator+coverage+file+logs/coverage.dat >> "$EXEC_LOG" 2>&1 || {
    echo "Simulation exited with non-zero. Tail:"
    tail -n 200 "$EXEC_LOG"
    exit 8
}

END_EXEC_TS=$(date +%s)
EXEC_ELAPSED=$((END_EXEC_TS - START_EXEC_TS))
echo "Simulation Run Time: ${EXEC_ELAPSED}s"

#############################################
#   COVERAGE REPORTING
#############################################
if [ -f "logs/coverage.dat" ]; then
    echo "--- Generating Coverage Report ---"

    verilator_coverage --annotate "$ARTIFACTS_DIR/coverage_annotated" logs/coverage.dat
    verilator_coverage logs/coverage.dat >> "$EXEC_LOG"

    echo "Coverage data processed in $ARTIFACTS_DIR/coverage_annotated"
fi

#############################################
#   GENERATE HTML COVERAGE REPORT
#############################################
if [ -f "logs/coverage.dat" ]; then
    echo "--- Processing coverage metrics ---"

    # Create info file
    verilator_coverage --write-info logs/coverage.info logs/coverage.dat

    # Generate HTML report
    # need lcov package for genhtml (in docker image)
    if command -v genhtml &> /dev/null; then
        genhtml logs/coverage.info --output-directory "$ARTIFACTS_DIR/coverage_html"
        echo "REPORT: Coverage HTML generated at $ARTIFACTS_DIR/coverage_html/index.html"
    else
        echo "WARNING: 'genhtml' not found. Install the 'lcov' package to generate HTML reports."
        # Fallback: Simple file annotation
        verilator_coverage --annotate "$ARTIFACTS_DIR/coverage_txt" logs/coverage.dat
    fi
fi

#############################################
#   FINAL ARTIFACTS AND SUMMARY (METRICAS)
#############################################

echo ""
echo "--- TIMING SUMMARY ---"
echo "Verilator C++ Generation: ${VERILATOR_ELAPSED}s"
echo "C++ Compilation (Make): ${MAKE_ELAPSED}s"
echo "Simulation Run Time: ${EXEC_ELAPSED}s"
TOTAL_ELAPSED=$((VERILATOR_ELAPSED + MAKE_ELAPSED + EXEC_ELAPSED))
echo "Total Pipeline Time: ${TOTAL_ELAPSED}s"
echo "Logs:"
echo "  build → $BUILD_LOG"
echo "  exec  → $EXEC_LOG"

if [ -f "waves.vcd" ]; then
    cp waves.vcd "$WAVE_FILE" || true
    rm -f waves.vcd
fi

exit 0