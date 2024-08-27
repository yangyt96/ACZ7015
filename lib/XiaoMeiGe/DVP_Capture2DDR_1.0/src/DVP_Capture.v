module DVP_Capture(
	input Rst_n,           //��λ
	input PCLK,            //����ʱ��
	input Vsync,           //��ͬ���ź�
	input Href,            //��ͬ���ź�
	input [7:0]Data,       //����
	input Send_En,         //���ݴ���ʹ��
	
	output [7:0]DataPixel, //��������
	
	output Cam_Rst_n,      //cmos ��λ�źţ��͵�ƽ��Ч
    output Cam_Pwdn,        //��Դ����ģʽѡ��

    output Frame_Clk,       //ʱ���ź�
    output Frame_FIFO_EN    //ʱ��ʹ���ź�
);

	reg r_Vsync;			
	reg r_Href;
	reg [7:0]r_Data;
	
	reg Frame_Valid;
	reg [3:0]FrameCnt;
	reg Dump_Frame;
	
	assign DataPixel = Dump_Frame ? Data : 8'd0;
	
	//����ͷӲ����λ,�̶��ߵ�ƽ
	assign  Cam_Rst_n = 1'b1;

	//��Դ����ģʽѡ�� 0������ģʽ 1����Դ����ģʽ
	assign  Cam_Pwdn  = 1'b0;
	
	//����ͷʱ��ʹ��
	assign  Frame_FIFO_EN = Href & Dump_Frame & Frame_Valid;
	
	//ʱ��Ϊ����ʱ��
	assign  Frame_Clk = PCLK;

	//����
	always@(posedge PCLK)
	begin
		r_Vsync <= Vsync;
		r_Href <= Href;
		r_Data <= Data;
	end
	
	reg[1:0] state;

	//��ͬ���ź���0��Ϊ1ʱ��֡������һ�����Ϊ10
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
	
	//��ͬ���ź���0��Ϊ1ʱ��֡������һ�����Ϊ10
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
	
	//���������ڵ���10֡ʱ��Dump_Frame��Ϊ1������Ϊ0
	always@(posedge PCLK or negedge Rst_n)
	if(!Rst_n)
		Dump_Frame <= 0;
	else if(FrameCnt >= 10)
		Dump_Frame <= 1'd1;
	else
		Dump_Frame <= 0;

endmodule
