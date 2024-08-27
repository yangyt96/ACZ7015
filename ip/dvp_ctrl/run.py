from vunit import VUnit
from pathlib import Path

ROOT = Path(__file__).parents[0]



vu = VUnit.from_argv(compile_builtins=False)

vu.add_verilog_builtins()

vu.add_external_library("xpm", "C:/intelFPGA/20.1/xil-2018.3/xpm")


######################################################################
# dvp_to_axis

liv_dvp_to_axis = vu.add_library("dvp_to_axis")

liv_dvp_to_axis.add_source_files([
    "E:/Xilinx/Vivado/2018.3/ids_lite/ISE/verilog/src/glbl.v",
    ROOT/"hdl/dvp_to_axis.sv",
    ROOT/"tb/dvp_to_axis_tb.sv",
])

liv_dvp_to_axis.set_sim_option(
    "modelsim.vsim_flags", 
    ["dvp_to_axis.glbl "]
)

liv_dvp_to_axis.set_sim_option(
    name="modelsim.init_file.gui",
    value=str(ROOT/"tb/dvp_to_axis_tb.do"),
    allow_empty=True
)


######################################################################
# dvp_ctrl

lib_dvp_ctrl = vu.add_library("dvp_ctrl")

lib_dvp_ctrl.add_source_files([
    "E:/Xilinx/Vivado/2018.3/ids_lite/ISE/verilog/src/glbl.v",
    ROOT/"hdl/dvp_to_axis.sv",
    ROOT/"hdl/dvp_axi_lite.sv",
    ROOT/"hdl/dvp_ctrl.sv",
    ROOT/"tb/dvp_ctrl_tb.sv",
])


lib_dvp_ctrl.set_sim_option(
    "modelsim.vsim_flags", 
    ["dvp_ctrl.glbl "],
    allow_empty=True
)


vu.main()