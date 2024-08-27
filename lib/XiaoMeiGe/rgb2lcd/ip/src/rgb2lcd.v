module rgb2lcd(
    input [23:0]rgb_data_in ,
    input rgb_vde,
    input rgb_hsync,
    input rgb_vsync,
    input pixel_clk,
    input vid_rst,
    output lcd_pclk,
    output lcd_rst,
    output reg lcd_hs,
    output reg lcd_vs,
    output reg lcd_de,
    output lcd_bl,
    
    //LCD�����������
    output [15:0]data
);

reg [23:0]RGB_Data;
wire [4:0]lcd_red;
wire [5:0]lcd_green;
wire [4:0]lcd_blue;

//LCD ���ݸ�ֵ
always @(posedge pixel_clk or negedge vid_rst) begin
    if(!vid_rst)
       RGB_Data <= 0;
    else if (rgb_vde == 1'b1)
       RGB_Data <= rgb_data_in;                        
    else
       RGB_Data <= 0;
end

//LCD�����źŸ�ֵ
always @(posedge pixel_clk or negedge vid_rst) begin
    if(!vid_rst) begin
        lcd_de <= 1'b0;
        lcd_hs <= 1'b0;
        lcd_vs <= 1'b0;    
    end
    else begin                                       
        lcd_de <= rgb_vde;
        lcd_hs <= rgb_hsync;
        lcd_vs <= rgb_vsync;
    end
end

assign lcd_pclk = pixel_clk;
assign lcd_rst  = vid_rst;
assign lcd_bl   = 1'b1;
assign lcd_red = RGB_Data[23:19];
assign lcd_green = RGB_Data[15:10];
assign lcd_blue = RGB_Data[7:3];
assign data = {lcd_red,lcd_green,lcd_blue};

endmodule
