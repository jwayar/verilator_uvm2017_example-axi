#!/usr/bin/env bash
# name: run_docker.sh
set -euo pipefail

# name: run_docker.sh - Docker infrastructure to run simulate_verilator.sh inside the container

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# default image variables (editar si hace falta)
FULL_REGISTRY_IMAGE_NAME="${FULL_REGISTRY_IMAGE_NAME:-registry.emtech.com.ar/cicd_template/fpga-ci-tools:verilator5042-uvm2017}"
LOCAL_IMAGE_ALIAS="${LOCAL_IMAGE_ALIAS:-verilator5042-uvm2017}"

# config file is always in the same directory as this script
CONFIG_FILE="${SCRIPT_DIR}/config.sh"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "ERROR: config file not found: $CONFIG_FILE"
    exit 2
fi

echo "--- Docker image: $FULL_REGISTRY_IMAGE_NAME (fallback: $LOCAL_IMAGE_ALIAS) ---"
echo "--- Project root: $PROJECT_ROOT ---"
echo "--- Using config: $CONFIG_FILE ---"

# try to pull registry image; fall back to local tag if fail
if docker pull "$FULL_REGISTRY_IMAGE_NAME"; then
    FULL_IMAGE_NAME="$FULL_REGISTRY_IMAGE_NAME"
    echo "Pulled image: $FULL_IMAGE_NAME"
else
    FULL_IMAGE_NAME="$LOCAL_IMAGE_ALIAS"
    echo "Failed to pull registry image, attempting local image: $FULL_IMAGE_NAME"
    if ! docker image inspect "$FULL_IMAGE_NAME" > /dev/null 2>&1; then
        echo "FATAL: Local image '$FULL_IMAGE_NAME' not found. Build or provide the image."
        exit 3
    fi
fi

# Run the container and execute the simulate script (mounted project root)
# === DEBUG MODE: open shell instead of running simulation ===
if [ "${DEBUG_SHELL:-0}" = "1" ]; then
    echo "=== DEBUG MODE ENABLED: Opening interactive shell inside the container ==="
    docker run --rm -it \
        -v "$PROJECT_ROOT:$PROJECT_ROOT" \
        -w "$PROJECT_ROOT" \
        "$FULL_IMAGE_NAME" \
        /bin/bash
    exit 0
fi

# === NORMAL MODE: run the simulation ===
docker run --rm -it \
    -v "$PROJECT_ROOT:$PROJECT_ROOT" \
    -w "$PROJECT_ROOT" \
    "$FULL_IMAGE_NAME" \
    /bin/bash -c "
        set -euo pipefail;
        # Change to the script directory and run simulate_verilator.sh
        # simulate_verilator.sh will automatically find config.sh in its own directory
        cd \"$PROJECT_ROOT/verilator_uvm_2017\" && \
        bash ./simulate_verilator.sh
    "
EXIT_CODE=$?

echo "-----------------------------------------"
if [ $EXIT_CODE -eq 0 ]; then
    echo "SUCCESS: Simulation finished (exit code 0)."
else
    echo "FAILED: Simulation exited with code $EXIT_CODE"
fi
echo "-----------------------------------------"

exit $EXIT_CODE