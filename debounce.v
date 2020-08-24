module debounce(opt,ipt,clk,rst_n);
	input ipt;
	input clk,rst_n;
	output opt;
	reg delay0;
	reg delay1;
	reg delay2;
	always@(posedge clk or negedge rst_n)
	begin
		if(~rst_n)
		begin
			delay0<=0;
			delay1<=0;
			delay2<=0;
		end
		else
		begin
			delay0<=ipt;
			delay1<=delay0;
			delay2<=delay1;
		end
	end
	assign opt=delay0&delay1&delay2;
endmodule