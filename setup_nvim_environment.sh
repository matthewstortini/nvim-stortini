#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_SCRIPT_TARGET="${1:-}"

if [[ -z "$ENV_SCRIPT_TARGET" ]]; then
  echo "Usage: ./setup_nvim_environment.sh /path/to/environment_script"
  exit 1
fi

if [[ ! -f "$REPO_DIR/bin/nvim-stortini" ]]; then
  echo "Error: bin/nvim-stortini not found in repo."
  exit 1
fi

if [[ ! -f "$ENV_SCRIPT_TARGET" ]]; then
  echo "Error: target environment script not found:"
  echo "  $ENV_SCRIPT_TARGET"
  exit 1
fi

NVIM_BLOCK=$(cat <<EOF

# nvim-stortini configuration package
if [ -f "$REPO_DIR/bin/nvim-stortini" ]; then
  export PATH="$REPO_DIR/bin:\$PATH"
  alias nv=nvim-stortini
fi
EOF
)

echo "This script is a convenience helper."
echo
echo "It will append a small block to your environment script that:"
echo "  - adds the nvim-stortini executable directory to your PATH"
echo "  - creates the alias 'nv' for launching nvim-stortini"
echo
echo "It will modify the following file:"
echo "  $ENV_SCRIPT_TARGET"
echo
read -r -p "Are you sure you want to continue? (y/n): " answer
if [[ "$answer" != "y" && "$answer" != "Y" ]]; then
  echo "Aborting."
  exit 0
fi

if grep -Fq '# nvim-stortini configuration package' "$ENV_SCRIPT_TARGET"; then
  echo "nvim-stortini block already exists in target file."
  read -r -p "Append another copy anyway? (y/n): " answer
  if [[ "$answer" != "y" && "$answer" != "Y" ]]; then
    echo "Aborting."
    exit 0
  fi
fi

echo "Updating environment script..."
printf "%s\n" "$NVIM_BLOCK" >> "$ENV_SCRIPT_TARGET"

echo "Done."
echo
echo "Added nvim-stortini PATH and alias setup to:"
echo "  $ENV_SCRIPT_TARGET"
echo
echo "To activate it in your current shell:"
echo "  source \"$ENV_SCRIPT_TARGET\""
