#!/usr/bin/env bash
set -euo pipefail

if [ "${EUID:-$(id -u)}" -ne 0 ]; then
    echo "This script installs OS-level prerequisites and must be run as root." >&2
    echo "Run: sudo .devcontainer/00_install_ubuntu_packages.sh" >&2
    exit 1
fi

# Mirror the base package installation performed in the Dockerfile. These
# packages cannot be installed into a Python virtual environment.
export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get install -y \
    software-properties-common \
    apt-utils \
    curl \
    zip \
    unzip \
    tar \
    gzip \
    ca-certificates \
    git \
    wget \
    build-essential \
    gcc \
    g++ \
    make \
    autoconf \
    automake \
    autotools-dev \
    cmake \
    ninja-build \
    pkg-config \
    gawk \
    bison \
    flex \
    texinfo \
    gperf \
    libtool \
    patchutils \
    bc \
    m4 \
    device-tree-compiler \
    python3 \
    python3-dev \
    python3-venv \
    python3-pip \
    libmpc-dev \
    libmpfr-dev \
    libgmp-dev \
    zlib1g-dev \
    libexpat1-dev \
    libglib2.0-dev \
    libncurses-dev \
    libssl-dev \
    tcl-dev \
    tk-dev \
    libcairo2-dev \
    mesa-common-dev \
    libglu1-mesa-dev \
    libx11-dev \
    libxpm-dev \
    libxext-dev \
    libxt-dev \
    tcsh \
    csh \
    nodejs \
    npm \
    nix-bin \
    verilator \
    librsvg2-bin \
    inkscape \
    vim \
    jq
mkdir -p /etc/nix
if ! grep -q "openlane.cachix.org" /etc/nix/nix.conf 2>/dev/null; then
    {
        echo "extra-substituters = https://openlane.cachix.org"
        echo "extra-trusted-public-keys = openlane.cachix.org-1:qqdwh+QMNGmZAuyeQJTH9ErW57OWSvdtuwfBKdS254E="
    } >> /etc/nix/nix.conf
fi
apt-get clean
rm -rf /var/lib/apt/lists/*
unset DEBIAN_FRONTEND
