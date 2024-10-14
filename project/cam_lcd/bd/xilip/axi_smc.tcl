# Create instance: axi_smc, and set properties
set axi_smc [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 axi_smc ]
set_property -dict [ list \
    CONFIG.NUM_SI {1} \
    ] $axi_smc