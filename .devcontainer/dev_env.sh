#!/usr/bin/env bash

# Source this file to use KryptoNyte's repo-local development environment.
if [ -n "${BASH_SOURCE:-}" ]; then
    _KRYPTONYTE_DEV_ENV_SOURCE="${BASH_SOURCE[0]}"
elif [ -n "${ZSH_VERSION:-}" ]; then
    _KRYPTONYTE_DEV_ENV_SOURCE="${(%):-%N}"
else
    _KRYPTONYTE_DEV_ENV_SOURCE="$0"
fi

_KRYPTONYTE_DEVCONTAINER_DIR=$(cd "$(dirname "$_KRYPTONYTE_DEV_ENV_SOURCE")" && pwd)
export KRYPTONYTE_REPO_ROOT="${KRYPTONYTE_REPO_ROOT:-$(cd "$_KRYPTONYTE_DEVCONTAINER_DIR/.." && pwd)}"
export KRYPTONYTE_VENV="${KRYPTONYTE_VENV:-$KRYPTONYTE_REPO_ROOT/.venv}"
export KRYPTONYTE_TOOLS_DIR="${KRYPTONYTE_TOOLS_DIR:-$KRYPTONYTE_VENV/tools}"

export SDKMAN_DIR="${SDKMAN_DIR:-$KRYPTONYTE_VENV/sdkman}"
export NPM_CONFIG_PREFIX="${NPM_CONFIG_PREFIX:-$KRYPTONYTE_VENV}"
export npm_config_prefix="${npm_config_prefix:-$NPM_CONFIG_PREFIX}"

_kryptonyte_prepend_path() {
    case ":$PATH:" in
        *":$1:"*) ;;
        *) export PATH="$1:$PATH" ;;
    esac
}

if [ -d "$KRYPTONYTE_VENV/bin" ]; then
    _kryptonyte_prepend_path "$KRYPTONYTE_VENV/bin"
fi

for _kryptonyte_tool_bin in \
    "$KRYPTONYTE_TOOLS_DIR/oss-cad-suite/bin" \
    "$KRYPTONYTE_TOOLS_DIR/riscv/bin" \
    "$KRYPTONYTE_TOOLS_DIR/skywater-pdk/magic-install/bin"; do
    if [ -d "$_kryptonyte_tool_bin" ]; then
        _kryptonyte_prepend_path "$_kryptonyte_tool_bin"
    fi
done

if [ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]; then
    _kryptonyte_had_nounset=false
    case $- in
        *u*) _kryptonyte_had_nounset=true && set +u ;;
    esac

    # shellcheck disable=SC1091
    source "$SDKMAN_DIR/bin/sdkman-init.sh"

    if [ "$_kryptonyte_had_nounset" = true ]; then
        set -u
    fi
fi

unset _KRYPTONYTE_DEVCONTAINER_DIR
unset _KRYPTONYTE_DEV_ENV_SOURCE
unset _kryptonyte_had_nounset
unset _kryptonyte_tool_bin
unset -f _kryptonyte_prepend_path
