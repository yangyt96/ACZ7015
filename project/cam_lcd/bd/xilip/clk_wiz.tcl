# Create instance: clk_wiz_0, and set properties
set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
set_property -dict [ list \
    CONFIG.CLKOUT1_JITTER {305.592} \
    CONFIG.CLKOUT1_PHASE_ERROR {298.923} \
    CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {24} \
    CONFIG.MMCM_CLKFBOUT_MULT_F {50.250} \
    CONFIG.MMCM_CLKOUT0_DIVIDE_F {41.875} \
    CONFIG.MMCM_DIVCLK_DIVIDE {5} \
    CONFIG.RESET_PORT {resetn} \
    CONFIG.RESET_TYPE {ACTIVE_LOW} \
    CONFIG.USE_LOCKED {false} \
    ] $clk_wiz_0