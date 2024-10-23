import os
import random
from pathlib import Path
from vunit import VUnit
from subprocess import call


os.environ["VUNIT_MODELSIM_PATH"] = "C:/intelFPGA/20.1/modelsim_ase/win32aloem"
os.environ["VUNIT_GHDL_PATH"] = "C:/GHDL/GHDL-v4.0.0/bin"

os.environ["VUNIT_SIMULATOR"] = "ghdl"
# os.environ["VUNIT_SIMULATOR"] = "modelsim"

ROOT = Path(__file__).resolve().parent

DUT_DIR = ROOT / "src"
TB_DIR = ROOT / "tb"


vu = VUnit.from_argv(compile_builtins=False)


vu.add_vhdl_builtins()
vu.add_osvvm()


lib = vu.add_library("lib")

lib.add_source_files([
    DUT_DIR / "adder_pipeline.vhd",
])


lib.add_source_files([
    TB_DIR / "adder_pipeline_tb.vhd",
])

#######################################
# constraint random test
#######################################

testbench = lib.entity("adder_pipeline_tb")
test_random = testbench.test("test_random")


random.seed(0)

for itr in range(3):
    generics = {
        "G_INPUT_REG": bool(random.randint(0, 1)),
        "G_OUTPUT_REG": bool(random.randint(0, 1)),
        "G_DATA_WIDTH": random.randint(1, 64)
    }
    generics["G_NUM_PIPE"] = random.randint(0, generics["G_DATA_WIDTH"])

    test_name = "test_random_"
    test_name += "_".join([str(x) for x in generics.values()])

    test_random.add_config(name=test_name,
                           generics=generics)





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

lib.set_sim_option("enable_coverage", True)

# lib.set_compile_option("rivierapro.vcom_flags", ["-coverage", "bs"])
# lib.set_compile_option("rivierapro.vlog_flags", ["-coverage", "bs"])
# lib.set_compile_option("modelsim.vcom_flags", ["+cover=bs"])
# lib.set_compile_option("modelsim.vlog_flags", ["+cover=bs"])
lib.set_compile_option("enable_coverage", True)


# vu.main()
vu.main(post_run=post_run)
