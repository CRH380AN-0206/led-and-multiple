module ledshow(en,clk,rst_n,led);
	input en,clk,rst_n;
	output reg [7:0]led;
	reg [7:0]warfarin;
	always @ (posedge clk or negedge rst_n)
	begin
		if(!rst_n)
		begin
			warfarin<=0;
		end
		else if(en==1)
		begin
			if(warfarin==0)
			begin
				led<=8'b1000_0001;
				warfarin<=1;
			end
			else if(warfarin==1)
			begin
				led<=8'b0100_0010;
				warfarin<=2;
			end
			else if(warfarin==2)
			begin
				led<=8'b0010_0100;
				warfarin<=3;
			end
			else if(warfarin==3)
			begin
				led<=8'b0001_1000;
				warfarin<=4;
			end
			else if(warfarin==4)
			begin
				led<=8'b0010_0100;
				warfarin<=5;
			end
			else if(warfarin==5)
			begin
				led<=8'b0100_0010;
				warfarin<=6;
			end
			else if(warfarin==6)
			begin
				led<=8'b1000_0001;
				warfarin<=7;
			end
			else if(warfarin==7)
			begin
				led<=8'b0000_0000;
				warfarin<=0;
			end
		end
		else if(en==0)
		begin
			led<=8'b0000_0000;
		end
	end
endmodule