#!/usr/bin/bash
# name: config.sh

#############################################
#   PROJECT PATHS
#############################################
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RTL_DIR="$PROJECT_ROOT/rtl"
SIM_DIR="$PROJECT_ROOT/tb_axis_amd_master_custom_slave"
RUN_DIR="$PROJECT_ROOT/run"
VIP_DIR="$PROJECT_ROOT/Vip"
SIM_MODELS_DIR="$SIM_DIR/sim_models/src" # Sim models (generados por Vivado ?)

#############################################
#   TOP + TEST
#############################################
TOP_MODULE="axis_tb_top"
UVM_TESTNAME="axis_tb_main_test"

# Tests
AVAILABLE_TESTS=(
  "axis_tb_main_test"
)

#############################################
#   VERILATOR + UVM CONFIG
#############################################
UVM_HOME="${UVM_HOME:-/usr/share/uvm}"
VERILATOR_FLAGS="-Wno-fatal --binary --assert --trace-vcd --skip-identical"
VERILATOR_EXTRA_DEFINES="+define+UVM_NO_DPI"
# VERILATOR_EXTRA_DEFINES="+define+UVM_NO_DPI +define+UVM_OBJECT_MUST_HAVE_CONSTRUCTOR

# --coverga : genera todo el coverage
# --trace-vcd : genera archivo VCD para visualizacion de señales
# --binary : optimiza la simulacion para velocidad (modo binario)
# --assert : habilita las aserciones en la simulacion
# --skip-identical : omite archivos idénticos para acelerar la compilación

# --cover-ucode : genera coverage a nivel de microcodigo (instrucciones)
# --cover-line : genera coverage a nivel de linea
# --cover-toggle : genera toggle coverage
# --trace-structs : genera trazas de estructuras (structs) en el VCD
# --trace-classes : genera trazas de clases en el VCD

#############################################
#   ** DV: ORDERED FILELIST FOR VERILATOR**
#############################################
MANUAL_FILE_ORDER=(
    # --- UVM core package ---
    # "$UVM_HOME/src/uvm_pkg.sv"

    # --- RTL WRAPPERS ---
    "$RTL_DIR/axi_stream_master_wrapper.v"
    "$RTL_DIR/axi_stream_receiver_wrapper.v"

    # ---- VIP: AMD_AXI_STREAM -----
    "$VIP_DIR/amd_axi_stream_vip/xillinxs_vip/axi_vip/xilinxs_vip_pkg.sv"
    "$VIP_DIR/amd_axi_stream_vip/xillinxs_vip/axi_vip/axi4stream_vip_axi4streampc.sv"
    "$VIP_DIR/amd_axi_stream_vip/xillinxs_vip/axi_vip/axi4stream_vip_if.sv"

    # --- VIP: AXI STREAM ---
    "$VIP_DIR/axi_stream_vip/axi_stream_agent_pkg.sv"
    "$VIP_DIR/axi_stream_vip/axi_stream_if.sv"

    # --- TB packages ---
    "$VIP_DIR/utils/src/utils_pkg.sv"
    "$SIM_DIR/axis_tb_defn_pkg.sv"
    "$SIM_DIR/axis_tb_scoreboard_pkg.sv"
    "$SIM_DIR/axis_tb_env_pkg.sv"
    "$SIM_DIR/axis_tb_test_pkg.sv"

    # --- TB top ---
    "$SIM_DIR/axis_tb_top.sv"
)

#############################################
#   OUTPUT DIRS
#############################################
ARTIFACTS_DIR="artifacts"
WAVE_FILE="$ARTIFACTS_DIR/waves.vcd"
LOG_FILE="$ARTIFACTS_DIR/simulation.log"

#############################################
#   BUILD
#############################################
MAKE_JOBS="${MAKE_JOBS:-$(nproc || echo 4)}"
VERILATOR_BUILD_DIR="obj_dir"