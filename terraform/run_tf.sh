#!/bin/bash

# Configuration
ACTION=$1      # plan, apply, destroy
ENV_NAME=$2    # e.g., pve
ENV_DIR="envs/$ENV_NAME"
ENV_FILE=".env"
DOCKER_CMD="docker compose run --rm terraform"

# 1. Validation
if [[ -z "$ACTION" || -z "$ENV_NAME" ]]; then
    echo "Usage: ./deploy.sh [plan|apply|destroy] [env_name]"
    echo "Example: ./deploy.sh plan pve"
    exit 1
fi

if [ ! -d "$ENV_DIR" ]; then
    echo "❌ Error: Environment directory '$ENV_DIR' not found."
    exit 1
fi

if [ ! -f "$ENV_FILE" ]; then
    echo "❌ Error: Secrets file '$ENV_FILE' missing. Create one from .env.example."
    exit 1
fi

# 2. Execution
echo "--- 🚀 Running $ACTION on $ENV_NAME ---"

# We use -chdir to point Terraform to the subdirectory
# and we pass the env-file to ensure secrets are loaded into the container
$DOCKER_CMD -chdir="$ENV_DIR" init -upgrade

case "$ACTION" in
    plan)
        $DOCKER_CMD -chdir="$ENV_DIR" plan
        ;;
    apply)
        $DOCKER_CMD -chdir="$ENV_DIR" apply -auto-approve
        ;;
    destroy)
        $DOCKER_CMD -chdir="$ENV_DIR" destroy -auto-approve
        ;;
    *)
        echo "❌ Error: Unknown action '$ACTION'. Use plan, apply, or destroy."
        exit 1
        ;;
esac