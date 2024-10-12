module dvp_ctrl #
  (
    parameter integer P_DVP_DATA_WIDTH = 8,
    parameter integer P_AXIS_DATA_WIDTH = 64, //! Multiply of P_DVP_DATA_WIDTH
    parameter integer P_AXIL_DATA_WIDTH = 32,
    parameter integer P_AXIL_ADDR_WIDTH = 4
  )
  (
    // DVP interface
    input logic i_dvp_pclk, //! input from board, min=48MHz, max=96MHz
    input logic i_dvp_vsync, //! input from board0
    input logic i_dvp_href, //! input from board
    input logic [P_DVP_DATA_WIDTH-1 : 0] i_dvp_data, //! input from board
    output logic o_dvp_resetb, //! output to board
    output logic o_dvp_pwdn, //! output to board
    output logic o_dvp_xvclk, //! output to board, connect directly from i_dvp_xvclk

    input logic i_dvp_xvclk, //! min=6Mhz. typ=24MHz, max=54MHz

    // AXI
    input logic i_axi_clk,
    input logic i_axi_rst,

    // AXI Stream
    //! @virtualbus m_axi_stream @dir out
    output logic m_axis_tvalid,
    input logic m_axis_tready,
    output logic [P_AXIS_DATA_WIDTH-1 : 0] m_axis_tdata,
    //! @end

    // AXI Lite
    //! @virtualbus s_axi_lite @dir in
    input logic [P_AXIL_ADDR_WIDTH-1 : 0] s_axil_awaddr,
    input logic [2 : 0] s_axil_awprot,
    input logic s_axil_awvalid,
    output logic s_axil_awready,

    input logic [P_AXIL_DATA_WIDTH-1 : 0] s_axil_wdata,
    input logic [P_AXIL_DATA_WIDTH/8 - 1 : 0] s_axil_wstrb,
    input logic s_axil_wvalid,
    output logic s_axil_wready,

    output logic [1 : 0] s_axil_bresp,
    output logic s_axil_bvalid,
    input logic s_axil_bready,

    input logic [P_AXIL_ADDR_WIDTH-1 : 0] s_axil_araddr,
    input logic [2 : 0] s_axil_arprot,
    input logic s_axil_arvalid,
    output logic s_axil_arready,

    output logic [P_AXIL_DATA_WIDTH-1 : 0] s_axil_rdata,
    output logic [1 : 0] s_axil_rresp,
    output logic s_axil_rvalid,
    input logic s_axil_rready
    //! @end
  );
  logic dvp_rst;

  logic axis_endian;

  logic dvp_ena;
  logic dvp_ena_cdc;

  logic [7:0] dvp_drop_vsync;
  logic [7:0] dvp_drop_vsync_cdc;

  logic [7:0] fifo_wr_stat;
  logic [7:0] fifo_wr_stat_cdc;
  logic [7:0] fifo_rd_stat;
  logic [15:0] fifo_wr_cnt;
  logic [15:0] fifo_wr_cnt_cdc;
  logic [15:0] fifo_rd_cnt;

  assign o_dvp_xvclk = i_dvp_xvclk;

  // ----------------------------------------
  // CDC: axi_clk -> dvp_clk
  // ----------------------------------------

  xpm_cdc_array_single #
    (
      .DEST_SYNC_FF(2),   // DECIMAL; range: 2-10
      .INIT_SYNC_FF(0),   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
      .SIM_ASSERT_CHK(0), // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
      .SRC_INPUT_REG(1),  // DECIMAL; 0=do not register input, 1=register input
      .WIDTH(2)           // DECIMAL; range: 1-1024
    )
    cdc_ctrl_axi_to_dvp
    (
      .dest_out({dvp_rst, dvp_ena_cdc}),
      .dest_clk(i_dvp_pclk),
      .src_clk(i_axi_clk),
      .src_in({i_axi_rst, dvp_ena})
    );

    //! This is a const val
  xpm_cdc_array_single #
    (
      .DEST_SYNC_FF(2),   // DECIMAL; range: 2-10
      .INIT_SYNC_FF(0),   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
      .SIM_ASSERT_CHK(0), // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
      .SRC_INPUT_REG(1),  // DECIMAL; 0=do not register input, 1=register input
      .WIDTH($bits(dvp_drop_vsync))           // DECIMAL; range: 1-1024
    )
    cdc_dvp_drop_vsync
    (
      .dest_out(dvp_drop_vsync_cdc),
      .dest_clk(i_dvp_pclk),
      .src_clk(i_axi_clk),
      .src_in(dvp_drop_vsync)
    );


  // ----------------------------------------
  // CDC: dvp_clk -> axi_clk
  // ----------------------------------------
  xpm_cdc_array_single #
    (
      .DEST_SYNC_FF(2),   // DECIMAL; range: 2-10
      .INIT_SYNC_FF(0),   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
      .SIM_ASSERT_CHK(0), // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
      .SRC_INPUT_REG(1),  // DECIMAL; 0=do not register input, 1=register input
      .WIDTH($bits(fifo_wr_cnt))           // DECIMAL; range: 1-1024
    )
    cdc_fifo_wr_cnt
    (
      .dest_out(fifo_wr_cnt_cdc),
      .dest_clk(i_axi_clk),
      .src_clk(i_dvp_pclk),
      .src_in(fifo_wr_cnt)
    );

  xpm_cdc_array_single #
    (
      .DEST_SYNC_FF(2),   // DECIMAL; range: 2-10
      .INIT_SYNC_FF(0),   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
      .SIM_ASSERT_CHK(0), // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
      .SRC_INPUT_REG(1),  // DECIMAL; 0=do not register input, 1=register input
      .WIDTH($bits(fifo_wr_stat)) // DECIMAL; range: 1-1024
    )
    cdc_fifo_wr_stat
    (
      .dest_out(fifo_wr_stat_cdc),
      .dest_clk(i_axi_clk),
      .src_clk(i_dvp_pclk),
      .src_in(fifo_wr_stat)
    );

  // ----------------------------------------
  // AXI Lite
  // ----------------------------------------

  dvp_axi_lite #
    (
      .C_S_AXI_DATA_WIDTH(P_AXIL_DATA_WIDTH),
      .C_S_AXI_ADDR_WIDTH(P_AXIL_ADDR_WIDTH)
    )
    dvp_axi_lite_inst
    (
      .o_axis_endian(axis_endian),

      .o_dvp_pwdn(o_dvp_pwdn),
      .o_dvp_resetb(o_dvp_resetb),
      .o_dvp_ena(dvp_ena),
      .o_dvp_drop_vsync(dvp_drop_vsync),

      .i_fifo_wr_stat(fifo_wr_stat_cdc),
      .i_fifo_rd_stat(fifo_rd_stat),
      .i_fifo_wr_cnt(fifo_wr_cnt_cdc),
      .i_fifo_rd_cnt(fifo_rd_cnt),

      .S_AXI_ACLK(i_axi_clk),
      .S_AXI_ARESETN(~i_axi_rst),
      .S_AXI_AWADDR(s_axil_awaddr),
      .S_AXI_AWPROT(s_axil_awprot),
      .S_AXI_AWVALID(s_axil_awvalid),
      .S_AXI_AWREADY(s_axil_awready),
      .S_AXI_WDATA(s_axil_wdata),
      .S_AXI_WSTRB(s_axil_wstrb),
      .S_AXI_WVALID(s_axil_wvalid),
      .S_AXI_WREADY(s_axil_wready),
      .S_AXI_BRESP(s_axil_bresp),
      .S_AXI_BVALID(s_axil_bvalid),
      .S_AXI_BREADY(s_axil_bready),
      .S_AXI_ARADDR(s_axil_araddr),
      .S_AXI_ARPROT(s_axil_arprot),
      .S_AXI_ARVALID(s_axil_arvalid),
      .S_AXI_ARREADY(s_axil_arready),
      .S_AXI_RDATA(s_axil_rdata),
      .S_AXI_RRESP(s_axil_rresp),
      .S_AXI_RVALID(s_axil_rvalid),
      .S_AXI_RREADY(s_axil_rready)
    );

  // ----------------------------------------
  // convert the dvp interface to axi stream
  // ----------------------------------------

  dvp_to_axis #
    (
      .P_DVP_DATA_WIDTH(P_DVP_DATA_WIDTH),
      .P_AXIS_DATA_WIDTH(64)
    )
    dvp_to_axis_inst
    (
      .i_dvp_pclk(i_dvp_pclk),
      .i_dvp_vsync(i_dvp_vsync),
      .i_dvp_href(i_dvp_href),
      .i_dvp_data(i_dvp_data),
      .i_dvp_ena(dvp_ena_cdc),
      .i_dvp_rst(dvp_rst),
      .i_dvp_drop_vsync(dvp_drop_vsync_cdc),
      .o_fifo_wr_stat(fifo_wr_stat),
      .o_fifo_wr_cnt(fifo_wr_cnt),
      .o_fifo_rd_stat(fifo_rd_stat),
      .o_fifo_rd_cnt(fifo_rd_cnt),
      .i_axis_clk(i_axi_clk),
      .i_axis_endian(axis_endian),
      .m_axis_tvalid(m_axis_tvalid),
      .m_axis_tready(m_axis_tready),
      .m_axis_tdata(m_axis_tdata)
    );


endmodule
