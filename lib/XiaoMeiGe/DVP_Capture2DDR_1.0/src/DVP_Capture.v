module DVP_Capture(
	input Rst_n,           //复位
	input PCLK,            //像素时钟
	input Vsync,           //场同步信号
	input Href,            //行同步信号
	input [7:0]Data,       //数据
	input Send_En,         //数据传输使能
	
	output [7:0]DataPixel, //像素数据
	
	output Cam_Rst_n,      //cmos 复位信号，低电平有效
    output Cam_Pwdn,        //电源休眠模式选择

    output Frame_Clk,       //时钟信号
    output Frame_FIFO_EN    //时钟使能信号
);

	reg r_Vsync;			
	reg r_Href;
	reg [7:0]r_Data;
	
	reg Frame_Valid;
	reg [3:0]FrameCnt;
	reg Dump_Frame;
	
	assign DataPixel = Dump_Frame ? Data : 8'd0;
	
	//摄像头硬件复位,固定高电平
	assign  Cam_Rst_n = 1'b1;

	//电源休眠模式选择 0：正常模式 1：电源休眠模式
	assign  Cam_Pwdn  = 1'b0;
	
	//摄像头时钟使能
	assign  Frame_FIFO_EN = Href & Dump_Frame & Frame_Valid;
	
	//时钟为像素时钟
	assign  Frame_Clk = PCLK;

	//打拍
	always@(posedge PCLK)
	begin
		r_Vsync <= Vsync;
		r_Href <= Href;
		r_Data <= Data;
	end
	
	reg[1:0] state;

	//场同步信号由0变为1时，帧计数加一，最大为10
	always@(posedge PCLK or negedge Rst_n)
	if(!Rst_n)	
	begin
		Frame_Valid <= 0;
		state <= 0;
	end
	else begin
        case(state)
            0:
                if(Send_En)
	               state <= 2'b1;    
            1:
                if({r_Vsync,Vsync}== 2'b10)
                begin
                    Frame_Valid <= 1;
                    state <= 2;
                end
                else
                    Frame_Valid <= 0;       
            2:
	           if(Send_En == 0)
	           begin
	               Frame_Valid <= 0;
	                state <= 0;
	          end
	          else
	          begin
	           Frame_Valid <= 1;
	                state <= 2;
	          end
	       default:
	           Frame_Valid = Frame_Valid;
        endcase
	end
	
	//场同步信号由0变为1时，帧计数加一，最大为10
	always@(posedge PCLK or negedge Rst_n)
	if(!Rst_n)	
		FrameCnt <= 0;
	else if({r_Vsync,Vsync}== 2'b01)begin
		if(FrameCnt >= 10)
			FrameCnt <= 4'd10;
		else
			FrameCnt <= FrameCnt + 1'd1;
	end
	else
		FrameCnt <= FrameCnt;
	
	//当计数大于等于10帧时，Dump_Frame变为1，否则为0
	always@(posedge PCLK or negedge Rst_n)
	if(!Rst_n)
		Dump_Frame <= 0;
	else if(FrameCnt >= 10)
		Dump_Frame <= 1'd1;
	else
		Dump_Frame <= 0;

endmodule
