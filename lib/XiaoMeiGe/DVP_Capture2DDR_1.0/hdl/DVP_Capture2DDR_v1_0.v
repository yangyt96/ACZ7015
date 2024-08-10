`timescale 1 ns / 1 ps

	module DVP_Capture2DDR_v1_0 #
	(
		// Users to add parameters here
        parameter WR_ADDRESS = 32'h1800000, //0x1800000 
        parameter WR_LENGTH = 768000,       //д�����ݳ���Ϊ1000��,1000*8�ֽ�=8000
        parameter ENDIAN_MODE = 1,   //��С��ģʽ��1Ϊ���ģʽ�����ֽڱ������ڴ�ĵ͵�ַ����0ΪС��ģʽ
		// User parameters ends
		// Do not modify the parameters beyond this line

		// Parameters of Axi Slave Bus Interface S00_AXI
		parameter integer C_S00_AXI_DATA_WIDTH	= 32,
		parameter integer C_S00_AXI_ADDR_WIDTH	= 4
	)
	(
		// Users to add ports here
		output [0:0] M_AXI_AWID,
		output [31:0] M_AXI_AWADDR,
		output [7:0] M_AXI_AWLEN,    // Burst Length:0-255
		output [2:0] M_AXI_AWSIZE,   // Burst Size:Fixed 2'b011
		output [1:0] M_AXI_AWBURST,  // Burst Type:Fixed 2'b01(Incremental Burst)
		output       M_AXI_AWLOCK,   // Lock: Fixed2'b00
		output [3:0] M_AXI_AWCACHE,  // Cache: Fiex2'b0011
		output [2:0] M_AXI_AWPROT,   // Protect: Fixed2'b000
		output [3:0] M_AXI_AWQOS,    // QoS: Fixed2'b0000
		output [0:0] M_AXI_AWUSER,   // User: Fixed32'd0
		output       M_AXI_AWVALID,
		input        M_AXI_AWREADY,
		output [63:0] M_AXI_WDATA,
		output [7:0] M_AXI_WSTRB,
		output       M_AXI_WLAST,
		output [0:0] M_AXI_WUSER,
		output       M_AXI_WVALID,
		input        M_AXI_WREADY,
		input [0:0]  M_AXI_BID,
		input [1:0]  M_AXI_BRESP,
		input [0:0]  M_AXI_BUSER,
		input        M_AXI_BVALID,
		output       M_AXI_BREADY,
		    
		output [0:0] M_AXI_ARID,
		output [31:0] M_AXI_ARADDR,
		output [7:0] M_AXI_ARLEN,
		output [2:0] M_AXI_ARSIZE,
		output [1:0] M_AXI_ARBURST,
		output [1:0] M_AXI_ARLOCK,
		output [3:0] M_AXI_ARCACHE,
		output [2:0] M_AXI_ARPROT,
		output [3:0] M_AXI_ARQOS,
		output [0:0] M_AXI_ARUSER,
		output       M_AXI_ARVALID,
		input        M_AXI_ARREADY,
		input [0:0]  M_AXI_RID,
		input [63:0] M_AXI_RDATA,
		input [1:0]  M_AXI_RRESP,
		input        M_AXI_RLAST,
		input [0:0]  M_AXI_RUSER,
		input        M_AXI_RVALID,
		output       M_AXI_RREADY,
		
		output       WR_FIFO_RE,
		input        WR_FIFO_EMPTY,
		input        WR_FIFO_AEMPTY,
		input [63:0] WR_FIFO_DATA,
      
        input PCLK,            //����ʱ��
        input Vsync,           //��ͬ���ź�
        input Href,            //��ͬ���ź�
        input [7:0]Data,       //����
        
        output [7:0]DataPixel,
        output Cam_Rst_n,      //cmos ��λ�źţ��͵�ƽ��Ч
        output Cam_Pwdn,        //��Դ����ģʽѡ��
        output Frame_Clk,
        output Frame_FIFO_EN,
        output FIFO_RST,
		// User ports ends
		// Do not modify the ports beyond this line


		// Ports of Axi Slave Bus Interface S00_AXI
		input wire  s00_axi_aclk,
		input wire  s00_axi_aresetn,
		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_awaddr,
		input wire [2 : 0] s00_axi_awprot,
		input wire  s00_axi_awvalid,
		output wire  s00_axi_awready,
		input wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_wdata,
		input wire [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb,
		input wire  s00_axi_wvalid,
		output wire  s00_axi_wready,
		output wire [1 : 0] s00_axi_bresp,
		output wire  s00_axi_bvalid,
		input wire  s00_axi_bready,
		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_araddr,
		input wire [2 : 0] s00_axi_arprot,
		input wire  s00_axi_arvalid,
		output wire  s00_axi_arready,
		output wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_rdata,
		output wire [1 : 0] s00_axi_rresp,
		output wire  s00_axi_rvalid,
		input wire  s00_axi_rready
	);

	   wire [31:0]REG0;
// Instantiation of Axi Bus Interface S00_AXI
	DVP_Capture2DDR_v1_0_S00_AXI # ( 
		.C_S_AXI_DATA_WIDTH(C_S00_AXI_DATA_WIDTH),
		.C_S_AXI_ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH)
	) DVP_Capture2DDR_v1_0_S00_AXI_inst (
		.S_AXI_ACLK(s00_axi_aclk),
		.S_AXI_ARESETN(s00_axi_aresetn),
		.S_AXI_AWADDR(s00_axi_awaddr),
		.S_AXI_AWPROT(s00_axi_awprot),
		.S_AXI_AWVALID(s00_axi_awvalid),
		.S_AXI_AWREADY(s00_axi_awready),
		.S_AXI_WDATA(s00_axi_wdata),
		.S_AXI_WSTRB(s00_axi_wstrb),
		.S_AXI_WVALID(s00_axi_wvalid),
		.S_AXI_WREADY(s00_axi_wready),
		.S_AXI_BRESP(s00_axi_bresp),
		.S_AXI_BVALID(s00_axi_bvalid),
		.S_AXI_BREADY(s00_axi_bready),
		.S_AXI_ARADDR(s00_axi_araddr),
		.S_AXI_ARPROT(s00_axi_arprot),
		.S_AXI_ARVALID(s00_axi_arvalid),
		.S_AXI_ARREADY(s00_axi_arready),
		.S_AXI_RDATA(s00_axi_rdata),
		.S_AXI_RRESP(s00_axi_rresp),
		.S_AXI_RVALID(s00_axi_rvalid),
		.S_AXI_RREADY(s00_axi_rready),
		.REG0(REG0)
	);

	// Add user logic here
	wire WR_READY;
	assign FIFO_RST = ~REG0[0];
	
    Data_to_DDR Data_to_DDR(
        .ARESETN(s00_axi_aresetn),
        .ACLK(s00_axi_aclk), 
        .ENDIAN_MODE(ENDIAN_MODE),   //��С������
        .M_AXI_AWID(M_AXI_AWID),
        .M_AXI_AWADDR(M_AXI_AWADDR),
        .M_AXI_AWLEN(M_AXI_AWLEN),   
        .M_AXI_AWSIZE(M_AXI_AWSIZE),  
        .M_AXI_AWBURST(M_AXI_AWBURST), 
        .M_AXI_AWLOCK(M_AXI_AWLOCK),  
        .M_AXI_AWCACHE(M_AXI_AWCACHE), 
        .M_AXI_AWPROT(M_AXI_AWPROT),  
        .M_AXI_AWQOS(M_AXI_AWQOS),   
        .M_AXI_AWUSER(M_AXI_AWUSER),  
        .M_AXI_AWVALID(M_AXI_AWVALID),
        .M_AXI_AWREADY(M_AXI_AWREADY),
        .M_AXI_WDATA(M_AXI_WDATA),
        .M_AXI_WSTRB(M_AXI_WSTRB),
        .M_AXI_WLAST(M_AXI_WLAST),
        .M_AXI_WUSER(M_AXI_WUSER),
        .M_AXI_WVALID(M_AXI_WVALID),
        .M_AXI_WREADY(M_AXI_WREADY),
        .M_AXI_BID(M_AXI_BID),
        .M_AXI_BRESP(M_AXI_BRESP),
        .M_AXI_BUSER(M_AXI_BUSER),
        .M_AXI_BVALID(M_AXI_BVALID),
        .M_AXI_BREADY(M_AXI_BREADY),
        .M_AXI_ARID(M_AXI_ARID),
        .M_AXI_ARADDR(M_AXI_ARADDR),
        .M_AXI_ARLEN(M_AXI_ARLEN),
        .M_AXI_ARSIZE(M_AXI_ARSIZE),
        .M_AXI_ARBURST(M_AXI_ARBURST),
        .M_AXI_ARLOCK(M_AXI_ARLOCK),
        .M_AXI_ARCACHE(M_AXI_ARCACHE),
        .M_AXI_ARPROT(M_AXI_ARPROT),
        .M_AXI_ARQOS(M_AXI_ARQOS),
        .M_AXI_ARUSER(M_AXI_ARUSER),
        .M_AXI_ARVALID(M_AXI_ARVALID),
        .M_AXI_ARREADY(M_AXI_ARREADY),
        .M_AXI_RID(M_AXI_RID),
        .M_AXI_RDATA(M_AXI_RDATA),
        .M_AXI_RRESP(M_AXI_RRESP),
        .M_AXI_RLAST(M_AXI_RLAST),
        .M_AXI_RUSER(M_AXI_RUSER),
        .M_AXI_RVALID(M_AXI_RVALID),
        .M_AXI_RREADY(M_AXI_RREADY),
        
        .MASTER_RST(~REG0[0]),
        .WR_START(WR_READY),
        .WR_ADRS(WR_ADDRESS),
        .WR_LEN(WR_LENGTH),
        .WR_READY(WR_READY),
        .WR_FIFO_RE(WR_FIFO_RE),
        .WR_FIFO_EMPTY(WR_FIFO_EMPTY),
        .WR_FIFO_AEMPTY(WR_FIFO_AEMPTY),
        .WR_FIFO_DATA(WR_FIFO_DATA),
        .WR_DONE()
);
	// -----------------------------------------------------
	// CDC control signal, REG0[0]
	// -----------------------------------------------------
	wire reg0_0_pclk;

	xpm_cdc_sync_rst #(
		.DEST_SYNC_FF(2),   // DECIMAL; range: 2-10
		.INIT(0),           // DECIMAL; 0=initialize synchronization registers to 0, 1=initialize synchronization
							// registers to 1
		.INIT_SYNC_FF(0),   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
		.SIM_ASSERT_CHK(0)  // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
	)
	xpm_cdc_sync_rst_reg0_inst (
		.dest_rst(reg0_0_pclk), // 1-bit output: src_rst synchronized to the destination clock domain. This output
							// is registered.

		.dest_clk(PCLK), // 1-bit input: Destination clock.
		.src_rst(REG0[0])    // 1-bit input: Source reset signal.
	);

	wire axi_resetn_dvp_pclk;

	xpm_cdc_sync_rst #(
		.DEST_SYNC_FF(2),   // DECIMAL; range: 2-10
		.INIT(0),           // DECIMAL; 0=initialize synchronization registers to 0, 1=initialize synchronization
							// registers to 1
		.INIT_SYNC_FF(0),   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
		.SIM_ASSERT_CHK(0)  // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
	)
	xpm_cdc_sync_rstn_ps_inst (
		.dest_rst(axi_resetn_dvp_pclk), // 1-bit output: src_rst synchronized to the destination clock domain. This output
							// is registered.

		.dest_clk(PCLK), // 1-bit input: Destination clock.
		.src_rst(s00_axi_aresetn)    // 1-bit input: Source reset signal.
	);

    DVP_Capture DVP_Capture (
        .Rst_n(axi_resetn_dvp_pclk),// this is async reset design, so no cdc is required, but the design is dangerous
        .PCLK(PCLK),            //����ʱ��
        .Vsync(Vsync),           //��ͬ���ź�
        .Href(Href),            //��ͬ���ź�
        .Data(Data),            //����
        .Send_En(reg0_0_pclk),         // active high
        
        .DataPixel(DataPixel),  //��������
        
        .Cam_Rst_n(Cam_Rst_n),  // not used
        .Cam_Pwdn(Cam_Pwdn),    // not used
    
        .Frame_Clk(Frame_Clk),  //ʱ���ź�
        .Frame_FIFO_EN(Frame_FIFO_EN)//FIFOʹ���ź�
    );
    
    
	// User logic ends

	endmodule
