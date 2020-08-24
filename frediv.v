module frediv(CLK_50M,nCR,CLK_Out);
	parameter N=25;//位宽
	parameter CLK_Freq=50000000;//50MHz时钟输入
	parameter OUT_Freq=1;//时钟输出
	input nCR,CLK_50M;//输入声明
	output reg CLK_Out;//输出端口声明
	reg[N-1:0] Count_DIV;//存放计数器输出值
	always@(posedge CLK_50M or negedge nCR)
	begin
	if(~nCR) begin//异步清零
	CLK_Out<=0;
	Count_DIV<=0;
	end
	else begin
	if(Count_DIV<(CLK_Freq/(2*OUT_Freq)-1))//计数器模
	Count_DIV<=Count_DIV+1'b1;//分频计数器增1计数
	else begin
	Count_DIV<=0;//输出清零
	CLK_Out<=~CLK_Out;//取反
	end
	end
	end
endmodule
//**********************************************************
/* module misaka(nRST,CLK_50,_1Hz);
	input CLK_50, nRST;
	//输入端口声明
	output _1Hz;
	//输出端口声明
	Divider50MHz	U3(.CLK_50M(CLK_50),//实例引用子模块
					.nCR (nRST),
					.CLK_Out(_1Hz));//10Hz
	defparam 		U3.N=6,
					U3.CLK_Freq=50,
					U3.OUT_Freq= 1;
	
endmodule */
