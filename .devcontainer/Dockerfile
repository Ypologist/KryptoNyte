FROM ubuntu:24.04

# Set non-interactive mode for APT to avoid prompts
ENV DEBIAN_FRONTEND=noninteractive

# Update and install OS-level prerequisites. Project-owned tools are installed
# later into the repo-local .venv by the install scripts.
RUN apt-get update -y && apt-get install -y \
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
    jq \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Configure the OpenLane binary cache for Nix-backed physical design flows.
RUN mkdir -p /etc/nix && \
    printf '%s\n' \
    'extra-substituters = https://openlane.cachix.org' \
    'extra-trusted-public-keys = openlane.cachix.org-1:qqdwh+QMNGmZAuyeQJTH9ErW57OWSvdtuwfBKdS254E=' \
    >> /etc/nix/nix.conf

# Unset non-interactive mode after installation
ENV DEBIAN_FRONTEND=

# Set default shell to bash
SHELL ["/bin/bash", "-c"]

CMD ["bash"]
