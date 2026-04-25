# KryptoNyte Installation Guide

This guide starts from a fresh clone and covers both Docker/devcontainer and native Ubuntu setup. The repository uses a split installation model:

- OS packages are installed by `.devcontainer/Dockerfile` or `.devcontainer/00_install_ubuntu_packages.sh`.
- Repo-owned tools are installed under `.venv`.
- Physical design runs are written under `.venv/physical_design`.

## Fresh Clone

```bash
git clone <repo-url> KryptoNyte
cd KryptoNyte
```

## Docker Prerequisites

If you want the devcontainer or manual Docker flow, install Docker first:

- Windows: install Docker Desktop from <https://docs.docker.com/desktop/setup/install/windows-install/>.
- macOS: install Docker Desktop from <https://docs.docker.com/installation/mac/>.
- Linux desktop: Docker Desktop is available from <https://docs.docker.com/desktop/setup/install/linux/>, but Docker Engine is also fine for this repository.
- Ubuntu server, WSL, or a minimal Linux install: Docker Engine is usually the lighter choice; use <https://docs.docker.com/engine/install/ubuntu/> for Ubuntu.

For Ubuntu 24.04 or WSL, the quickest distro-package install is:

```bash
sudo apt-get update
sudo apt-get install -y docker.io docker-buildx docker-compose-v2
sudo usermod -aG docker "$USER"
```

After `usermod`, sign out and back in so your shell picks up the `docker` group. If you want Docker's newest upstream packages instead of Ubuntu's packaged version, use Docker's official Ubuntu Engine instructions linked above.

After installation, verify Docker works:

```bash
docker version
docker run --rm hello-world
```

On Linux, your user may need permission to access the Docker daemon. The `usermod` command above handles that for Ubuntu; follow Docker's post-install steps for your distribution if `docker version` only works with `sudo`.

## Option 1: Dev Container or Codespace

The easiest path is to open the repository as a VS Code Dev Container or GitHub Codespace. The devcontainer builds from `.devcontainer/Dockerfile`, which installs the Ubuntu packages needed by the rest of the scripts, including `nix-bin` for OpenLane2 physical design.

On first create, `.devcontainer/devcontainer.json` runs:

```bash
.devcontainer/install_sbt_and_gcc.sh
```

That creates `.venv`, installs SDKMAN under `.venv/sdkman`, and installs Java/SBT/Scala there. In a new terminal, the environment should be loaded automatically. To load it in the current shell:

```bash
source .devcontainer/dev_env.sh
```

Then install the remaining tool groups as needed:

```bash
.devcontainer/install_rtl_tools.sh
.devcontainer/install_riscv_compiler_tools.sh
.devcontainer/install_riscv_conformance_tests.sh
.devcontainer/install_physical_design_tools.sh
```

The RISC-V compiler build is long-running and can take tens of minutes.

## Option 2: Manual Docker

You can also build and run the same image directly:

```bash
docker build -f .devcontainer/Dockerfile -t kryptonyte-dev .devcontainer
docker run --rm -it -v "$PWD:/workspace/KryptoNyte" -w /workspace/KryptoNyte kryptonyte-dev bash
```

Inside the container, run:

```bash
.devcontainer/install_sbt_and_gcc.sh
source .devcontainer/dev_env.sh
.devcontainer/install_rtl_tools.sh
.devcontainer/install_riscv_compiler_tools.sh
.devcontainer/install_riscv_conformance_tests.sh
```

For physical design:

```bash
.devcontainer/install_physical_design_tools.sh
```

OpenLane2 uses Nix, which is a system-level prerequisite and does not install into `.venv`. The Dockerfile installs `nix-bin`; if you use a custom image and `nix` or `nix-shell` is missing, install Nix in the container first, then rerun the physical design installer.

## Option 3: Native Ubuntu 24.04 or WSL

Install OS prerequisites first:

```bash
sudo .devcontainer/00_install_ubuntu_packages.sh
```

That prerequisite script installs `nix-bin` as well. If your distribution does not provide `nix-bin`, install Nix from <https://nixos.org/download/> before running the physical design flow.

Then install repo-owned tools:

```bash
.devcontainer/install_sbt_and_gcc.sh
source .devcontainer/dev_env.sh
.devcontainer/install_rtl_tools.sh
.devcontainer/install_riscv_compiler_tools.sh
.devcontainer/install_riscv_conformance_tests.sh
.devcontainer/install_physical_design_tools.sh
```

## Installed Paths

```text
.venv/
|-- bin/                         # Python venv executables, firtool, sv2v, netlistsvg
|-- sdkman/                      # Java, SBT, Scala
|-- tools/
|   |-- oss-cad-suite/           # Yosys, nextpnr, and related RTL tools
|   |-- riscv/                   # RISC-V GNU toolchain, Spike, pk
|   |-- riscv-conformance/       # RISC-V architecture/conformance tests
|   `-- skywater-pdk/            # SkyWater PDK, Open PDKs, Magic, OpenLane2 checkout
`-- physical_design/             # OpenLane2 run output, reports, generated configs
```

## Smoke Checks

Load the environment:

```bash
source .devcontainer/dev_env.sh
```

Check basic tools:

```bash
sbt --version
firtool --version
sv2v --version
riscv64-unknown-elf-gcc --version
spike --help
```

Run an RTL compile:

```bash
cd rtl
sbt compile
```

Run conformance for a core:

```bash
cd tests
./run_riscv_conformance_tests.sh --processor zeronyte --smoke-test
```

Run physical design after installing physical design tools:

```bash
cd physical_design
./generate_physical_design.sh --module-name ZeroNyteRV32ICore
```

Results are written to `.venv/physical_design` by default.

## Notes

- The install scripts no longer use `--with-sudo`; only the OS prerequisite script needs root.
- `.venv` is intentionally ignored by git.
- Re-run a tool installer with `--upgrade` to refresh that tool group.
- The Dockerfile and Ubuntu prerequisite script install `nix-bin`; OpenLane2 execution still depends on system Nix because Nix manages `/nix`, not `.venv`.
