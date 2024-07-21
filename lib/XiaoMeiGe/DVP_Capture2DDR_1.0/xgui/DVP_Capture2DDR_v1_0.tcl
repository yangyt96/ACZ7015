# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  ipgui::add_param $IPINST -name "WR_ADDRESS"
  ipgui::add_param $IPINST -name "WR_LENGTH"
  ipgui::add_param $IPINST -name "ENDIAN_MODE"

}

proc update_PARAM_VALUE.ENDIAN_MODE { PARAM_VALUE.ENDIAN_MODE } {
	# Procedure called to update ENDIAN_MODE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ENDIAN_MODE { PARAM_VALUE.ENDIAN_MODE } {
	# Procedure called to validate ENDIAN_MODE
	return true
}

proc update_PARAM_VALUE.WR_ADDRESS { PARAM_VALUE.WR_ADDRESS } {
	# Procedure called to update WR_ADDRESS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.WR_ADDRESS { PARAM_VALUE.WR_ADDRESS } {
	# Procedure called to validate WR_ADDRESS
	return true
}

proc update_PARAM_VALUE.WR_LENGTH { PARAM_VALUE.WR_LENGTH } {
	# Procedure called to update WR_LENGTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.WR_LENGTH { PARAM_VALUE.WR_LENGTH } {
	# Procedure called to validate WR_LENGTH
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_DATA_WIDTH { PARAM_VALUE.C_S00_AXI_DATA_WIDTH } {
	# Procedure called to update C_S00_AXI_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_DATA_WIDTH { PARAM_VALUE.C_S00_AXI_DATA_WIDTH } {
	# Procedure called to validate C_S00_AXI_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_ADDR_WIDTH { PARAM_VALUE.C_S00_AXI_ADDR_WIDTH } {
	# Procedure called to update C_S00_AXI_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_ADDR_WIDTH { PARAM_VALUE.C_S00_AXI_ADDR_WIDTH } {
	# Procedure called to validate C_S00_AXI_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_BASEADDR { PARAM_VALUE.C_S00_AXI_BASEADDR } {
	# Procedure called to update C_S00_AXI_BASEADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_BASEADDR { PARAM_VALUE.C_S00_AXI_BASEADDR } {
	# Procedure called to validate C_S00_AXI_BASEADDR
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_HIGHADDR { PARAM_VALUE.C_S00_AXI_HIGHADDR } {
	# Procedure called to update C_S00_AXI_HIGHADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_HIGHADDR { PARAM_VALUE.C_S00_AXI_HIGHADDR } {
	# Procedure called to validate C_S00_AXI_HIGHADDR
	return true
}


proc update_MODELPARAM_VALUE.C_S00_AXI_DATA_WIDTH { MODELPARAM_VALUE.C_S00_AXI_DATA_WIDTH PARAM_VALUE.C_S00_AXI_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXI_DATA_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXI_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S00_AXI_ADDR_WIDTH { MODELPARAM_VALUE.C_S00_AXI_ADDR_WIDTH PARAM_VALUE.C_S00_AXI_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXI_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXI_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.WR_ADDRESS { MODELPARAM_VALUE.WR_ADDRESS PARAM_VALUE.WR_ADDRESS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.WR_ADDRESS}] ${MODELPARAM_VALUE.WR_ADDRESS}
}

proc update_MODELPARAM_VALUE.WR_LENGTH { MODELPARAM_VALUE.WR_LENGTH PARAM_VALUE.WR_LENGTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.WR_LENGTH}] ${MODELPARAM_VALUE.WR_LENGTH}
}

proc update_MODELPARAM_VALUE.ENDIAN_MODE { MODELPARAM_VALUE.ENDIAN_MODE PARAM_VALUE.ENDIAN_MODE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ENDIAN_MODE}] ${MODELPARAM_VALUE.ENDIAN_MODE}
}

