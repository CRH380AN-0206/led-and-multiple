module displayhex(clk,seg_leds,seg_nCS,rst_n,number);
	input clk;
	input [23:0]number;
	input rst_n;
	output wire [7:0]seg_leds;
	output reg [5:0]seg_nCS;
	reg [3:0]data;
	reg [5:0]times;
	initial begin 
	data<=0;
	end
	initial begin
	times<=0;
	end
	always @ (posedge clk or negedge rst_n)
	begin
	if(~rst_n)
	begin
		times<=0;
		data<=0;
	end
	else
	begin
		if(times == 0)
		begin
		data <= number[3:0];
		seg_nCS <= 6'b01_11_11;
		times<=1;
		end
		else if(times == 1)
		begin
		data <= number[7:4];
		seg_nCS <= 6'b10_11_11;
		times<=2;
		end
		else if(times == 2)
		begin
		data <= number[11:8];
		seg_nCS <= 6'b11_01_11;
		times<=3;
		end
		else if(times == 3)
		begin
		data <= number[15:12];
		seg_nCS <= 6'b11_10_11;
		times<=4;
		end
		else if(times == 4)
		begin
		data <= number[19:16];
		seg_nCS <= 6'b11_11_01;
		times<=5;
		end
		else if(times == 5)
		begin
		data <= number[23:20];
		seg_nCS <= 6'b11_11_10;
		times<=0;
		end
	
	end
	end
	SEG7_LUT seg_leds0(seg_leds,data);
endmodule