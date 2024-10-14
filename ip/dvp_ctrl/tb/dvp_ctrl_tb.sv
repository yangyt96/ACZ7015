
`include "vunit_defines.svh"
// `ìnclude "uvm_macros.svh"

 module dvp_ctrl_tb;

   // Parameters
   localparam integer P_DVP_DATA_WIDTH = 8;
   localparam integer P_AXIS_DATA_WIDTH = 64;
   localparam integer P_AXIL_DATA_WIDTH = 32;
   localparam integer P_AXIL_ADDR_WIDTH = 4;

   //Ports
   reg  i_dvp_pclk;
   reg  i_dvp_vsync;
   reg  i_dvp_href;
   reg [P_DVP_DATA_WIDTH-1 : 0] i_dvp_data;
   wire  o_dvp_resetb;
   wire  o_dvp_pwdn;
   wire  o_dvp_xvclk;
   reg  i_dvp_xvclk;
   reg  i_axi_clk;
   reg  i_axi_rst;
   wire  m_axis_tvalid;
   reg  m_axis_tready;
   wire [P_AXIS_DATA_WIDTH-1 : 0] m_axis_tdata;
   reg [P_AXIL_ADDR_WIDTH-1 : 0] s_axil_awaddr;
   reg [2 : 0] s_axil_awprot;
   reg  s_axil_awvalid;
   wire  s_axil_awready;
   reg [P_AXIL_DATA_WIDTH-1 : 0] s_axil_wdata;
   reg [P_AXIL_DATA_WIDTH/8 - 1 : 0] s_axil_wstrb;
   reg  s_axil_wvalid;
   wire  s_axil_wready;
   wire [1 : 0] s_axil_bresp;
   wire  s_axil_bvalid;
   reg  s_axil_bready;
   reg [P_AXIL_ADDR_WIDTH-1 : 0] s_axil_araddr;
   reg [2 : 0] s_axil_arprot;
   reg  s_axil_arvalid;
   wire  s_axil_arready;
   wire [P_AXIL_DATA_WIDTH-1 : 0] s_axil_rdata;
   wire [1 : 0] s_axil_rresp;
   wire  s_axil_rvalid;
   reg  s_axil_rready;

   dvp_ctrl #
     (
       .P_DVP_DATA_WIDTH(P_DVP_DATA_WIDTH),
       .P_AXIS_DATA_WIDTH(P_AXIS_DATA_WIDTH),
       .P_AXIL_DATA_WIDTH(P_AXIL_DATA_WIDTH),
       .P_AXIL_ADDR_WIDTH(P_AXIL_ADDR_WIDTH)
     )
     dvp_ctrl_inst
     (
       .i_dvp_pclk(i_dvp_pclk),
       .i_dvp_vsync(i_dvp_vsync),
       .i_dvp_href(i_dvp_href),
       .i_dvp_data(i_dvp_data),
       .o_dvp_resetb(o_dvp_resetb),
       .o_dvp_pwdn(o_dvp_pwdn),
       .o_dvp_xvclk(o_dvp_xvclk),
       .i_dvp_xvclk(i_dvp_xvclk),
       .i_axi_clk(i_axi_clk),
       .i_axi_rst(i_axi_rst),
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

   `TEST_SUITE
     begin
       // It is possible to create a basic test bench without any test cases
       $display("Hello world");
     end

     //always #5  clk = ! clk ;

   endmodule
