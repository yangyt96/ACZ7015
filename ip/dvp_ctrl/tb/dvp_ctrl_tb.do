onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group tb -radix hexadecimal /dvp_ctrl_tb/runner_cfg
add wave -noupdate -group tb -radix hexadecimal /dvp_ctrl_tb/i_dvp_pclk
add wave -noupdate -group tb -radix hexadecimal /dvp_ctrl_tb/i_dvp_vsync
add wave -noupdate -group tb -radix hexadecimal /dvp_ctrl_tb/i_dvp_href
add wave -noupdate -group tb -radix hexadecimal /dvp_ctrl_tb/i_dvp_data
add wave -noupdate -group tb -radix hexadecimal /dvp_ctrl_tb/o_dvp_resetb
add wave -noupdate -group tb -radix hexadecimal /dvp_ctrl_tb/o_dvp_pwdn
add wave -noupdate -group tb -radix hexadecimal /dvp_ctrl_tb/o_dvp_xvclk
add wave -noupdate -group tb -radix hexadecimal /dvp_ctrl_tb/i_dvp_xvclk
add wave -noupdate -group tb -radix hexadecimal /dvp_ctrl_tb/i_axi_clk
add wave -noupdate -group tb -radix hexadecimal /dvp_ctrl_tb/i_axi_rst
add wave -noupdate -group tb -radix hexadecimal /dvp_ctrl_tb/m_axis_tvalid
add wave -noupdate -group tb -radix hexadecimal /dvp_ctrl_tb/m_axis_tready
add wave -noupdate -group tb -radix hexadecimal /dvp_ctrl_tb/m_axis_tdata
add wave -noupdate -group tb -radix hexadecimal /dvp_ctrl_tb/s_axil_awaddr
add wave -noupdate -group tb -radix hexadecimal /dvp_ctrl_tb/s_axil_awprot
add wave -noupdate -group tb -radix hexadecimal /dvp_ctrl_tb/s_axil_awvalid
add wave -noupdate -group tb -radix hexadecimal /dvp_ctrl_tb/s_axil_awready
add wave -noupdate -group tb -radix hexadecimal /dvp_ctrl_tb/s_axil_wdata
add wave -noupdate -group tb -radix hexadecimal /dvp_ctrl_tb/s_axil_wstrb
add wave -noupdate -group tb -radix hexadecimal /dvp_ctrl_tb/s_axil_wvalid
add wave -noupdate -group tb -radix hexadecimal /dvp_ctrl_tb/s_axil_wready
add wave -noupdate -group tb -radix hexadecimal /dvp_ctrl_tb/s_axil_bresp
add wave -noupdate -group tb -radix hexadecimal /dvp_ctrl_tb/s_axil_bvalid
add wave -noupdate -group tb -radix hexadecimal /dvp_ctrl_tb/s_axil_bready
add wave -noupdate -group tb -radix hexadecimal /dvp_ctrl_tb/s_axil_araddr
add wave -noupdate -group tb -radix hexadecimal /dvp_ctrl_tb/s_axil_arprot
add wave -noupdate -group tb -radix hexadecimal /dvp_ctrl_tb/s_axil_arvalid
add wave -noupdate -group tb -radix hexadecimal /dvp_ctrl_tb/s_axil_arready
add wave -noupdate -group tb -radix hexadecimal /dvp_ctrl_tb/s_axil_rdata
add wave -noupdate -group tb -radix hexadecimal /dvp_ctrl_tb/s_axil_rresp
add wave -noupdate -group tb -radix hexadecimal /dvp_ctrl_tb/s_axil_rvalid
add wave -noupdate -group tb -radix hexadecimal /dvp_ctrl_tb/s_axil_rready
add wave -noupdate -group tb -radix hexadecimal /dvp_ctrl_tb/clk_period
add wave -noupdate -group tb -radix hexadecimal /dvp_ctrl_tb/P_DVP_DATA_WIDTH
add wave -noupdate -group tb -radix hexadecimal /dvp_ctrl_tb/P_AXIS_DATA_WIDTH
add wave -noupdate -group tb -radix hexadecimal /dvp_ctrl_tb/P_AXIL_DATA_WIDTH
add wave -noupdate -group tb -radix hexadecimal /dvp_ctrl_tb/P_AXIL_ADDR_WIDTH
add wave -noupdate -group tb -radix hexadecimal /dvp_ctrl_tb/axil_bus
add wave -noupdate -group top -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/P_DVP_DATA_WIDTH
add wave -noupdate -group top -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/P_AXIS_DATA_WIDTH
add wave -noupdate -group top -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/P_AXIL_DATA_WIDTH
add wave -noupdate -group top -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/P_AXIL_ADDR_WIDTH
add wave -noupdate -group top -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/i_dvp_pclk
add wave -noupdate -group top -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/i_dvp_vsync
add wave -noupdate -group top -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/i_dvp_href
add wave -noupdate -group top -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/i_dvp_data
add wave -noupdate -group top -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/o_dvp_resetb
add wave -noupdate -group top -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/o_dvp_pwdn
add wave -noupdate -group top -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/o_dvp_xvclk
add wave -noupdate -group top -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/i_dvp_xvclk
add wave -noupdate -group top -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/i_axi_clk
add wave -noupdate -group top -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/i_axi_rst
add wave -noupdate -group top -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/m_axis_tvalid
add wave -noupdate -group top -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/m_axis_tready
add wave -noupdate -group top -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/m_axis_tdata
add wave -noupdate -group top -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/s_axil_awaddr
add wave -noupdate -group top -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/s_axil_awprot
add wave -noupdate -group top -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/s_axil_awvalid
add wave -noupdate -group top -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/s_axil_awready
add wave -noupdate -group top -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/s_axil_wdata
add wave -noupdate -group top -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/s_axil_wstrb
add wave -noupdate -group top -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/s_axil_wvalid
add wave -noupdate -group top -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/s_axil_wready
add wave -noupdate -group top -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/s_axil_bresp
add wave -noupdate -group top -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/s_axil_bvalid
add wave -noupdate -group top -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/s_axil_bready
add wave -noupdate -group top -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/s_axil_araddr
add wave -noupdate -group top -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/s_axil_arprot
add wave -noupdate -group top -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/s_axil_arvalid
add wave -noupdate -group top -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/s_axil_arready
add wave -noupdate -group top -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/s_axil_rdata
add wave -noupdate -group top -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/s_axil_rresp
add wave -noupdate -group top -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/s_axil_rvalid
add wave -noupdate -group top -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/s_axil_rready
add wave -noupdate -group top -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_rst
add wave -noupdate -group top -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/axis_endian
add wave -noupdate -group top -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_ena
add wave -noupdate -group top -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_ena_cdc
add wave -noupdate -group top -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_drop_vsync
add wave -noupdate -group top -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_drop_vsync_cdc
add wave -noupdate -group top -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/fifo_wr_stat
add wave -noupdate -group top -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/fifo_wr_stat_cdc
add wave -noupdate -group top -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/fifo_rd_stat
add wave -noupdate -group top -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/fifo_wr_cnt
add wave -noupdate -group top -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/fifo_wr_cnt_cdc
add wave -noupdate -group top -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/fifo_rd_cnt
add wave -noupdate -group dvp_to_axis -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/P_DVP_DATA_WIDTH
add wave -noupdate -group dvp_to_axis -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/P_AXIS_DATA_WIDTH
add wave -noupdate -group dvp_to_axis -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/P_FIFO_WRITE_DEPTH
add wave -noupdate -group dvp_to_axis -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/C_FIFO_WR_CNT_WIDTH
add wave -noupdate -group dvp_to_axis -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/C_FIFO_RD_CNT_WIDTH
add wave -noupdate -group dvp_to_axis -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/i_dvp_pclk
add wave -noupdate -group dvp_to_axis -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/i_dvp_vsync
add wave -noupdate -group dvp_to_axis -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/i_dvp_href
add wave -noupdate -group dvp_to_axis -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/i_dvp_data
add wave -noupdate -group dvp_to_axis -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/i_dvp_ena
add wave -noupdate -group dvp_to_axis -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/i_dvp_rst
add wave -noupdate -group dvp_to_axis -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/i_dvp_drop_vsync
add wave -noupdate -group dvp_to_axis -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/o_fifo_wr_stat
add wave -noupdate -group dvp_to_axis -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/o_fifo_wr_cnt
add wave -noupdate -group dvp_to_axis -radix hexadecimal -childformat {{{/dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/o_fifo_rd_stat[7]} -radix hexadecimal} {{/dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/o_fifo_rd_stat[6]} -radix hexadecimal} {{/dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/o_fifo_rd_stat[5]} -radix hexadecimal} {{/dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/o_fifo_rd_stat[4]} -radix hexadecimal} {{/dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/o_fifo_rd_stat[3]} -radix hexadecimal} {{/dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/o_fifo_rd_stat[2]} -radix hexadecimal} {{/dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/o_fifo_rd_stat[1]} -radix hexadecimal} {{/dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/o_fifo_rd_stat[0]} -radix hexadecimal}} -expand -subitemconfig {{/dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/o_fifo_rd_stat[7]} {-height 15 -radix hexadecimal} {/dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/o_fifo_rd_stat[6]} {-height 15 -radix hexadecimal} {/dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/o_fifo_rd_stat[5]} {-height 15 -radix hexadecimal} {/dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/o_fifo_rd_stat[4]} {-height 15 -radix hexadecimal} {/dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/o_fifo_rd_stat[3]} {-height 15 -radix hexadecimal} {/dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/o_fifo_rd_stat[2]} {-height 15 -radix hexadecimal} {/dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/o_fifo_rd_stat[1]} {-height 15 -radix hexadecimal} {/dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/o_fifo_rd_stat[0]} {-height 15 -radix hexadecimal}} /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/o_fifo_rd_stat
add wave -noupdate -group dvp_to_axis -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/o_fifo_rd_cnt
add wave -noupdate -group dvp_to_axis -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/i_axis_clk
add wave -noupdate -group dvp_to_axis -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/i_axis_endian
add wave -noupdate -group dvp_to_axis -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/m_axis_tvalid
add wave -noupdate -group dvp_to_axis -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/m_axis_tready
add wave -noupdate -group dvp_to_axis -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/m_axis_tdata
add wave -noupdate -group dvp_to_axis -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/dvp_vsync
add wave -noupdate -group dvp_to_axis -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/dvp_href
add wave -noupdate -group dvp_to_axis -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/dvp_data
add wave -noupdate -group dvp_to_axis -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/dvp_vld
add wave -noupdate -group dvp_to_axis -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/dvp_cnt
add wave -noupdate -group dvp_to_axis -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/dvp_mask
add wave -noupdate -group dvp_to_axis -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/wr_en
add wave -noupdate -group dvp_to_axis -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/wr_din
add wave -noupdate -group dvp_to_axis -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/wr_rst_busy
add wave -noupdate -group dvp_to_axis -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/wr_full
add wave -noupdate -group dvp_to_axis -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/rd_en
add wave -noupdate -group dvp_to_axis -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/rd_dout
add wave -noupdate -group dvp_to_axis -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/rd_rst_busy
add wave -noupdate -group dvp_to_axis -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/rd_empty
add wave -noupdate -group lite -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/C_S_AXI_DATA_WIDTH
add wave -noupdate -group lite -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/C_S_AXI_ADDR_WIDTH
add wave -noupdate -group lite -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/ADDR_LSB
add wave -noupdate -group lite -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/OPT_MEM_ADDR_BITS
add wave -noupdate -group lite -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/o_axis_endian
add wave -noupdate -group lite -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/o_dvp_pwdn
add wave -noupdate -group lite -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/o_dvp_resetb
add wave -noupdate -group lite -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/o_dvp_ena
add wave -noupdate -group lite -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/o_dvp_drop_vsync
add wave -noupdate -group lite -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/i_fifo_wr_stat
add wave -noupdate -group lite -radix hexadecimal -childformat {{{/dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/i_fifo_rd_stat[7]} -radix hexadecimal} {{/dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/i_fifo_rd_stat[6]} -radix hexadecimal} {{/dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/i_fifo_rd_stat[5]} -radix hexadecimal} {{/dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/i_fifo_rd_stat[4]} -radix hexadecimal} {{/dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/i_fifo_rd_stat[3]} -radix hexadecimal} {{/dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/i_fifo_rd_stat[2]} -radix hexadecimal} {{/dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/i_fifo_rd_stat[1]} -radix hexadecimal} {{/dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/i_fifo_rd_stat[0]} -radix hexadecimal}} -expand -subitemconfig {{/dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/i_fifo_rd_stat[7]} {-radix hexadecimal} {/dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/i_fifo_rd_stat[6]} {-radix hexadecimal} {/dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/i_fifo_rd_stat[5]} {-radix hexadecimal} {/dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/i_fifo_rd_stat[4]} {-radix hexadecimal} {/dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/i_fifo_rd_stat[3]} {-radix hexadecimal} {/dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/i_fifo_rd_stat[2]} {-radix hexadecimal} {/dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/i_fifo_rd_stat[1]} {-radix hexadecimal} {/dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/i_fifo_rd_stat[0]} {-radix hexadecimal}} /dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/i_fifo_rd_stat
add wave -noupdate -group lite -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/i_fifo_wr_cnt
add wave -noupdate -group lite -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/i_fifo_rd_cnt
add wave -noupdate -group lite -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/S_AXI_ACLK
add wave -noupdate -group lite -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/S_AXI_ARESETN
add wave -noupdate -group lite -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/S_AXI_AWADDR
add wave -noupdate -group lite -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/S_AXI_AWPROT
add wave -noupdate -group lite -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/S_AXI_AWVALID
add wave -noupdate -group lite -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/S_AXI_AWREADY
add wave -noupdate -group lite -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/S_AXI_WDATA
add wave -noupdate -group lite -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/S_AXI_WSTRB
add wave -noupdate -group lite -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/S_AXI_WVALID
add wave -noupdate -group lite -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/S_AXI_WREADY
add wave -noupdate -group lite -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/S_AXI_BRESP
add wave -noupdate -group lite -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/S_AXI_BVALID
add wave -noupdate -group lite -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/S_AXI_BREADY
add wave -noupdate -group lite -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/S_AXI_ARADDR
add wave -noupdate -group lite -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/S_AXI_ARPROT
add wave -noupdate -group lite -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/S_AXI_ARVALID
add wave -noupdate -group lite -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/S_AXI_ARREADY
add wave -noupdate -group lite -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/S_AXI_RDATA
add wave -noupdate -group lite -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/S_AXI_RRESP
add wave -noupdate -group lite -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/S_AXI_RVALID
add wave -noupdate -group lite -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/S_AXI_RREADY
add wave -noupdate -group lite -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/axi_awaddr
add wave -noupdate -group lite -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/axi_awready
add wave -noupdate -group lite -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/axi_wready
add wave -noupdate -group lite -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/axi_bresp
add wave -noupdate -group lite -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/axi_bvalid
add wave -noupdate -group lite -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/axi_araddr
add wave -noupdate -group lite -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/axi_arready
add wave -noupdate -group lite -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/axi_rdata
add wave -noupdate -group lite -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/axi_rresp
add wave -noupdate -group lite -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/axi_rvalid
add wave -noupdate -group lite -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/slv_reg0
add wave -noupdate -group lite -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/slv_reg1
add wave -noupdate -group lite -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/slv_reg2
add wave -noupdate -group lite -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/slv_reg3
add wave -noupdate -group lite -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/slv_reg_rden
add wave -noupdate -group lite -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/slv_reg_wren
add wave -noupdate -group lite -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/reg_data_out
add wave -noupdate -group lite -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/byte_index
add wave -noupdate -group lite -radix hexadecimal /dvp_ctrl_tb/dvp_ctrl_inst/dvp_axi_lite_inst/aw_en
add wave -noupdate -expand -group fifo /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/xpm_fifo_async_inst/FIFO_MEMORY_TYPE
add wave -noupdate -expand -group fifo /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/xpm_fifo_async_inst/ECC_MODE
add wave -noupdate -expand -group fifo /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/xpm_fifo_async_inst/RELATED_CLOCKS
add wave -noupdate -expand -group fifo /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/xpm_fifo_async_inst/FIFO_WRITE_DEPTH
add wave -noupdate -expand -group fifo /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/xpm_fifo_async_inst/WRITE_DATA_WIDTH
add wave -noupdate -expand -group fifo /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/xpm_fifo_async_inst/WR_DATA_COUNT_WIDTH
add wave -noupdate -expand -group fifo /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/xpm_fifo_async_inst/PROG_FULL_THRESH
add wave -noupdate -expand -group fifo /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/xpm_fifo_async_inst/FULL_RESET_VALUE
add wave -noupdate -expand -group fifo /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/xpm_fifo_async_inst/USE_ADV_FEATURES
add wave -noupdate -expand -group fifo /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/xpm_fifo_async_inst/READ_MODE
add wave -noupdate -expand -group fifo /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/xpm_fifo_async_inst/FIFO_READ_LATENCY
add wave -noupdate -expand -group fifo /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/xpm_fifo_async_inst/READ_DATA_WIDTH
add wave -noupdate -expand -group fifo /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/xpm_fifo_async_inst/RD_DATA_COUNT_WIDTH
add wave -noupdate -expand -group fifo /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/xpm_fifo_async_inst/PROG_EMPTY_THRESH
add wave -noupdate -expand -group fifo /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/xpm_fifo_async_inst/DOUT_RESET_VALUE
add wave -noupdate -expand -group fifo /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/xpm_fifo_async_inst/CDC_SYNC_STAGES
add wave -noupdate -expand -group fifo /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/xpm_fifo_async_inst/WAKEUP_TIME
add wave -noupdate -expand -group fifo /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/xpm_fifo_async_inst/EN_ADV_FEATURE_ASYNC
add wave -noupdate -expand -group fifo /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/xpm_fifo_async_inst/P_FIFO_MEMORY_TYPE
add wave -noupdate -expand -group fifo /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/xpm_fifo_async_inst/P_COMMON_CLOCK
add wave -noupdate -expand -group fifo /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/xpm_fifo_async_inst/P_ECC_MODE
add wave -noupdate -expand -group fifo /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/xpm_fifo_async_inst/P_READ_MODE
add wave -noupdate -expand -group fifo /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/xpm_fifo_async_inst/P_WAKEUP_TIME
add wave -noupdate -expand -group fifo /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/xpm_fifo_async_inst/sleep
add wave -noupdate -expand -group fifo /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/xpm_fifo_async_inst/rst
add wave -noupdate -expand -group fifo /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/xpm_fifo_async_inst/wr_clk
add wave -noupdate -expand -group fifo /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/xpm_fifo_async_inst/wr_en
add wave -noupdate -expand -group fifo /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/xpm_fifo_async_inst/din
add wave -noupdate -expand -group fifo /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/xpm_fifo_async_inst/full
add wave -noupdate -expand -group fifo /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/xpm_fifo_async_inst/prog_full
add wave -noupdate -expand -group fifo /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/xpm_fifo_async_inst/wr_data_count
add wave -noupdate -expand -group fifo /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/xpm_fifo_async_inst/overflow
add wave -noupdate -expand -group fifo /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/xpm_fifo_async_inst/wr_rst_busy
add wave -noupdate -expand -group fifo /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/xpm_fifo_async_inst/almost_full
add wave -noupdate -expand -group fifo /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/xpm_fifo_async_inst/wr_ack
add wave -noupdate -expand -group fifo /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/xpm_fifo_async_inst/rd_clk
add wave -noupdate -expand -group fifo /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/xpm_fifo_async_inst/rd_en
add wave -noupdate -expand -group fifo /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/xpm_fifo_async_inst/dout
add wave -noupdate -expand -group fifo /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/xpm_fifo_async_inst/empty
add wave -noupdate -expand -group fifo /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/xpm_fifo_async_inst/prog_empty
add wave -noupdate -expand -group fifo /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/xpm_fifo_async_inst/rd_data_count
add wave -noupdate -expand -group fifo /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/xpm_fifo_async_inst/underflow
add wave -noupdate -expand -group fifo /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/xpm_fifo_async_inst/rd_rst_busy
add wave -noupdate -expand -group fifo /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/xpm_fifo_async_inst/almost_empty
add wave -noupdate -expand -group fifo /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/xpm_fifo_async_inst/data_valid
add wave -noupdate -expand -group fifo /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/xpm_fifo_async_inst/injectsbiterr
add wave -noupdate -expand -group fifo /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/xpm_fifo_async_inst/injectdbiterr
add wave -noupdate -expand -group fifo /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/xpm_fifo_async_inst/sbiterr
add wave -noupdate -expand -group fifo /dvp_ctrl_tb/dvp_ctrl_inst/dvp_to_axis_inst/xpm_fifo_async_inst/dbiterr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {159662 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 376
configure wave -valuecolwidth 40
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {653272 ps}
