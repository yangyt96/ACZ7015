# Create instance: v_axi4s_vid_out_0, and set properties
set v_axi4s_vid_out_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_axi4s_vid_out:4.0 v_axi4s_vid_out_0 ]
set_property -dict [ list \
    CONFIG.C_HAS_ASYNC_CLK {1} \
    ] $v_axi4s_vid_out_0