# Create instance: DVP_Capture2DDR_0, and set properties
set DVP_Capture2DDR_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:DVP_Capture2DDR:1.0 DVP_Capture2DDR_0 ]
set_property -dict [ list \
    CONFIG.ENDIAN_MODE {1} \
    ] $DVP_Capture2DDR_0
