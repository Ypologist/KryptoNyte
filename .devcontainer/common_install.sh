#!/usr/bin/env bash

_KRYPTONYTE_COMMON_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
# shellcheck disable=SC1091
source "$_KRYPTONYTE_COMMON_DIR/dev_env.sh"

ensure_local_venv() {
    if [ ! -f "$KRYPTONYTE_VENV/pyvenv.cfg" ]; then
        if ! command -v python3 >/dev/null 2>&1; then
            echo "python3 is required to create $KRYPTONYTE_VENV" >&2
            echo "Install OS prerequisites first, for example: sudo .devcontainer/00_install_ubuntu_packages.sh" >&2
            return 1
        fi

        python3 -m venv "$KRYPTONYTE_VENV"
    fi

    mkdir -p "$KRYPTONYTE_VENV/bin" "$KRYPTONYTE_TOOLS_DIR"
    export PATH="$KRYPTONYTE_VENV/bin:$PATH"
}

install_python_build_tools() {
    ensure_local_venv
    "$KRYPTONYTE_VENV/bin/python" -m pip install --upgrade pip setuptools wheel
}

add_dev_env_to_shell_profile() {
    local shell_profile=""
    if [ -n "${BASH_VERSION:-}" ]; then
        shell_profile="$HOME/.bashrc"
    elif [ -n "${ZSH_VERSION:-}" ]; then
        shell_profile="$HOME/.zshrc"
    fi

    if [ -n "$shell_profile" ] && [ -w "$shell_profile" ]; then
        if ! grep -q "KryptoNyte dev environment" "$shell_profile"; then
            {
                echo ""
                echo "# KryptoNyte dev environment"
                echo "source \"$KRYPTONYTE_REPO_ROOT/.devcontainer/dev_env.sh\""
            } >> "$shell_profile"
        fi
    fi
}

require_commands() {
    local missing=()
    local command_name

    for command_name in "$@"; do
        if ! command -v "$command_name" >/dev/null 2>&1; then
            missing+=("$command_name")
        fi
    done

    if [ "${#missing[@]}" -ne 0 ]; then
        echo "Missing required OS commands: ${missing[*]}" >&2
        echo "Install OS prerequisites first, for example: sudo .devcontainer/00_install_ubuntu_packages.sh" >&2
        return 1
    fi
}

confirm_continue() {
    local prompt="${1:-Continue? (Y/n): }"

    if [ ! -t 0 ]; then
        return 0
    fi

    local reply
    read -p "$prompt" -n 1 -r reply || return 0
    echo
    [[ ! $reply =~ ^[Nn]$ ]]
}

unset _KRYPTONYTE_COMMON_DIR
