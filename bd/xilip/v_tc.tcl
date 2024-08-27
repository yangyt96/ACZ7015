# Create instance: v_tc_0, and set properties
set v_tc_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_tc:6.1 v_tc_0 ]
set_property -dict [ list \
    CONFIG.enable_detection {false} \
    ] $v_tc_0