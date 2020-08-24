module _8bitmultclk(z,x,y,clk,rst_n);
	input [7:0]x,y;
	input clk,rst_n;
	output wire[15:0]z;
	reg [7:0]a,b;
	always@(posedge clk or negedge rst_n)
	begin
		if(!rst_n)
		begin
			a<=0;
			b<=0;
		end
		else
		begin
			a<=x;
			b<=y;
		end
	end
	assign z=x*y;
endmodule