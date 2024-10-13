module dvp_ctrl_wrapper #
  (
    parameter integer P_DVP_DATA_WIDTH = 8,
    parameter integer P_AXIS_DATA_WIDTH = 64, //! Multiply of P_DVP_DATA_WIDTH
    parameter integer P_AXIL_DATA_WIDTH = 32,
    parameter integer P_AXIL_ADDR_WIDTH = 4
  )
  (
    // DVP interface
    input wire i_dvp_pclk, //! input from board, min=48MHz, max=96MHz
    input wire i_dvp_vsync, //! input from board0
    input wire i_dvp_href, //! input from board
    input wire [P_DVP_DATA_WIDTH-1 : 0] i_dvp_data, //! input from board
    output wire o_dvp_resetb, //! output to board
    output wire o_dvp_pwdn, //! output to board
    output wire o_dvp_xvclk, //! output to board, connect directly from i_dvp_xvclk

    input wire i_dvp_xvclk, //! min=6Mhz. typ=24MHz, max=54MHz

    // AXI
    input wire i_axi_clk,
    input wire i_axi_rstn,

    // AXI Stream
    //! @virtualbus m_axi_stream @dir out
    output wire m_axis_tvalid,
    input wire m_axis_tready,
    output wire [P_AXIS_DATA_WIDTH-1 : 0] m_axis_tdata,
    //! @end

    // AXI Lite
    //! @virtualbus s_axi_lite @dir in
    input wire [P_AXIL_ADDR_WIDTH-1 : 0] s_axil_awaddr,
    input wire [2 : 0] s_axil_awprot,
    input wire s_axil_awvalid,
    output wire s_axil_awready,

    input wire [P_AXIL_DATA_WIDTH-1 : 0] s_axil_wdata,
    input wire [P_AXIL_DATA_WIDTH/8 - 1 : 0] s_axil_wstrb,
    input wire s_axil_wvalid,
    output wire s_axil_wready,

    output wire [1 : 0] s_axil_bresp,
    output wire s_axil_bvalid,
    input wire s_axil_bready,

    input wire [P_AXIL_ADDR_WIDTH-1 : 0] s_axil_araddr,
    input wire [2 : 0] s_axil_arprot,
    input wire s_axil_arvalid,
    output wire s_axil_arready,

    output wire [P_AXIL_DATA_WIDTH-1 : 0] s_axil_rdata,
    output wire [1 : 0] s_axil_rresp,
    output wire s_axil_rvalid,
    input wire s_axil_rready
    //! @end
  );

  dvp_ctrl # (
             .P_DVP_DATA_WIDTH(P_DVP_DATA_WIDTH),
             .P_AXIS_DATA_WIDTH(P_AXIS_DATA_WIDTH),
             .P_AXIL_DATA_WIDTH(P_AXIL_DATA_WIDTH),
             .P_AXIL_ADDR_WIDTH(P_AXIL_ADDR_WIDTH)
           )
           dvp_ctrl_inst (
             .i_dvp_pclk(i_dvp_pclk),
             .i_dvp_vsync(i_dvp_vsync),
             .i_dvp_href(i_dvp_href),
             .i_dvp_data(i_dvp_data),
             .o_dvp_resetb(o_dvp_resetb),
             .o_dvp_pwdn(o_dvp_pwdn),
             .o_dvp_xvclk(o_dvp_xvclk),
             .i_dvp_xvclk(i_dvp_xvclk),
             .i_axi_clk(i_axi_clk),
             .i_axi_rst(~i_axi_rstn),
             .m_axis_tvalid(m_axis_tvalid),
             .m_axis_tready(m_axis_tready),
             .m_axis_tdata(m_axis_tdata),
             .s_axil_awaddr(s_axil_awaddr),
             .s_axil_awprot(s_axil_awprot),
             .s_axil_awvalid(s_axil_awvalid),
             .s_axil_awready(s_axil_awready),
             .s_axil_wdata(s_axil_wdata),
             .s_axil_wstrb(s_axil_wstrb),
             .s_axil_wvalid(s_axil_wvalid),
             .s_axil_wready(s_axil_wready),
             .s_axil_bresp(s_axil_bresp),
             .s_axil_bvalid(s_axil_bvalid),
             .s_axil_bready(s_axil_bready),
             .s_axil_araddr(s_axil_araddr),
             .s_axil_arprot(s_axil_arprot),
             .s_axil_arvalid(s_axil_arvalid),
             .s_axil_arready(s_axil_arready),
             .s_axil_rdata(s_axil_rdata),
             .s_axil_rresp(s_axil_rresp),
             .s_axil_rvalid(s_axil_rvalid),
             .s_axil_rready(s_axil_rready)
           );

endmodule
