# Create instance: rgb565to888_0, and set properties
set rgb565to888_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:rgb565to888:1.0 rgb565to888_0 ]
set_property -dict [ list \
    CONFIG.RGB_SET {0} \
    ] $rgb565to888_0