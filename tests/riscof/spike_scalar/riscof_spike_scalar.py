import logging
import os
import re
import shutil

import riscof.utils as utils
from riscof.pluginTemplate import pluginTemplate

logger = logging.getLogger()


class spike_scalar(pluginTemplate):
    __model__ = "Spike"
    __version__ = "0.1"

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        config = kwargs.get("config")
        if config is None:
            raise SystemExit("spike_scalar plugin requires configuration")

        spike_dir = config.get("PATH", "")
        self.spike_exe = os.path.join(spike_dir, "spike")
        self.pluginpath = os.path.abspath(config["pluginpath"])
        self.isa_spec = os.path.abspath(config["ispec"])
        self.platform_spec = os.path.abspath(config["pspec"])

    def initialise(self, suite, work_dir, compliance_env):
        self.work_dir = work_dir
        self.suite_dir = suite
        self.compliance_env = compliance_env
        self.linker = os.path.join(self.pluginpath, "env", "link.ld")
        self.local_env = os.path.join(self.pluginpath, "env")

    def build(self, isa_yaml, platform_yaml):
        ispec = utils.load_yaml(isa_yaml)["hart0"]
        self.xlen = "64" if 64 in ispec["supported_xlen"] else "32"
        self.spike_isa = self._spike_isa_from_yaml(ispec["ISA"])
        self.abi = "lp64" if self.xlen == "64" else "ilp32"

        if shutil.which("riscv64-unknown-elf-gcc") is None:
            logger.error("riscv64-unknown-elf-gcc: executable not found. Please check environment setup.")
            raise SystemExit
        if shutil.which(self.spike_exe) is None:
            logger.error(self.spike_exe + ": executable not found. Please check environment setup.")
            raise SystemExit

    def runTests(self, testList):
        for _, testentry in testList.items():
            test_dir = testentry["work_dir"]
            elf_path = os.path.join(test_dir, "my.elf")
            sig_path = os.path.join(test_dir, self.name[:-1] + ".signature")

            macros = ""
            if testentry["macros"]:
                macros = " -D" + " -D".join(testentry["macros"])

            compile_cmd = (
                f"riscv64-unknown-elf-gcc -march={testentry['isa'].lower()} -mabi={self.abi} "
                f"-static -mcmodel=medany -fvisibility=hidden -nostdlib -nostartfiles "
                f"-T {self.linker} -I {self.local_env} -I {self.compliance_env} "
                f"{testentry['test_path']} -o {elf_path}{macros}"
            )
            run_cmd = (
                f"{self.spike_exe} --isa={self.spike_isa} +signature={sig_path} "
                f"+signature-granularity=4 {elf_path}"
            )

            logger.debug("Compiling reference test: " + testentry["test_path"])
            utils.shellCommand(compile_cmd).run(cwd=test_dir)
            logger.debug("Executing reference on Spike: " + run_cmd)
            utils.shellCommand(run_cmd).run(cwd=test_dir)

    @staticmethod
    def _spike_isa_from_yaml(isa):
        match = re.match(r"RV(32|64)([A-Z]+)(.*)", isa)
        if match is None:
            raise SystemExit(f"Unsupported ISA string for Spike reference: {isa}")

        xlen, single_letters, extensions = match.groups()
        base = "rv" + xlen
        for ext in "iemafdqc":
            if ext.upper() in single_letters:
                base += ext

        normalized_exts = []
        for ext in re.findall(r"Z[a-zA-Z0-9]+", extensions):
            normalized_exts.append(ext.lower())

        if "Zicsr" in isa and "zicsr" not in normalized_exts:
            normalized_exts.append("zicsr")
        if "Zifencei" in isa and "zifencei" not in normalized_exts:
            normalized_exts.append("zifencei")

        if normalized_exts:
            base += "_" + "_".join(normalized_exts)
        return base

