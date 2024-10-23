import os
import random
from pathlib import Path
from vunit import VUnit

from subprocess import call


os.environ["VUNIT_MODELSIM_PATH"] = "C:/intelFPGA/20.1/modelsim_ase/win32aloem"
os.environ["VUNIT_SIMULATOR"] = "modelsim"
# os.environ["VUNIT_SIMULATOR"] = "iverilog"

ROOT = Path(__file__).resolve().parent

DUT_DIR = ROOT / "src"
TB_DIR = ROOT / "tb"


vu = VUnit.from_argv(compile_builtins=False)

vu.add_verilog_builtins()

lib = vu.add_library("lib")


lib.add_source_files([
    DUT_DIR / "add_pipe.sv",
])


lib.add_source_files([
    TB_DIR / "add_pipe_tb.sv",
])

#######################################
# constraint random test
#######################################

testbench = lib.module("add_pipe_tb")

test_names = [
    "test_carry_a",
    "test_carry_b",
    "test_random",
    "test_full",
    "test_pipeline",
]

tests = [testbench.test(x) for x in test_names]


gens = set()
random.seed(0)
for itr in range(1000):

    ###############################################
    # generate test case
    data_size = random.randint(4, 128)
    num_pipe = random.randint(1, data_size - 1)
    gen = (data_size, num_pipe)

    while gen in gens:
        data_size = random.randint(4, 128)
        num_pipe = random.randint(1, data_size - 1)
        gen = (data_size, num_pipe)

    gens.add(gen)

    generics = {
        "P_DATA_SIZE": data_size,
        "P_NUM_PIPE": num_pipe
    }

    for test in tests:
        test.add_config(
            name="test_{}_{}".format(data_size,
                                     num_pipe),
            generics=generics
        )


#######################################
# coverage report
#######################################

def post_run(results):
    results.merge_coverage(file_name="coverage_data")
    if vu.get_simulator_name() == "ghdl":
        if results._simulator_if._backend == "gcc":
            call(["gcovr", "coverage_data"])
        else:
            call(["gcovr", "-a", "coverage_data/gcovr.json"])

# lib.set_sim_option("enable_coverage", True)

# lib.set_compile_option("rivierapro.vcom_flags", ["-coverage", "bs"])
# lib.set_compile_option("rivierapro.vlog_flags", ["-coverage", "bs"])
# lib.set_compile_option("modelsim.vcom_flags", ["+cover=bs"])
# lib.set_compile_option("modelsim.vlog_flags", ["+cover=bs"])
# lib.set_compile_option("enable_coverage", True)


#######################################
# run test
#######################################
vu.main()
# vu.main(post_run=post_run)
