from vunit import VUnit
from pathlib import Path

ROOT = Path(__file__).parents[0]



vu = VUnit.from_argv(compile_builtins=False)
vu.add_vhdl_builtins()
vu.add_verilog_builtins()
vu.add_verification_components()

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
    [liv_dvp_to_axis.name+".glbl "]
)

liv_dvp_to_axis.set_sim_option(
    name="modelsim.init_file.gui",
    value=str(ROOT/"tb/dvp_to_axis_tb.do"),
)


######################################################################
# dvp_ctrl

lib_dvp_ctrl = vu.add_library("dvp_ctrl")

lib_dvp_ctrl.add_source_files([
    "E:/Xilinx/Vivado/2018.3/ids_lite/ISE/verilog/src/glbl.v",
    ROOT/"hdl/dvp_to_axis.sv",
    ROOT/"hdl/dvp_axi_lite.sv",
    ROOT/"hdl/dvp_ctrl.sv",
    ROOT/"tb/dvp_ctrl_tb.vhd",
])

lib_dvp_ctrl.set_sim_option(
    "modelsim.vsim_flags", 
    [lib_dvp_ctrl.name+".glbl "],
)

lib_dvp_ctrl.set_sim_option(
    name="modelsim.init_file.gui",
    value=str(ROOT/"tb/dvp_ctrl_tb.do"),
)


vu.main()