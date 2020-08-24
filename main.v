module main(rst_n,clk,keys,leds,seg_nCS,seg_leds);
	input rst_n;	//复位
	input clk;	//50MHZ的时钟
	input [7:0]keys;//未经消抖按键
	output reg  [7:0]leds;//一排led	
	output wire [5:0]seg_nCS;//位选
	output wire [7:0]seg_leds;//段选
	wire krst,key1, key2, key3, key4, key5, key6, key7;//消抖后按键们
	wire fre1k,fre10,fre2,fre100;//分频后的各种频率
	reg [23:0]number;//输入数码管的数字
	reg [2:0]crtsta,nxtsta,nktsta;//现在状态，下一状态（key1~key4），下一状态(key5)，
	//因为在不同的always逻辑块中，不可以对同一个reg变量进行了赋值
	//但是自动乘法器需要一个较低的频率否则看不清
	//其它按键需要一个较高的频率，因此要分出两个不同的always运用不同的频率
	reg [2:0]rststa=3'b000,dpysta=3'b001,mulsta=3'b010,mdpsta=3'b011,atosta=3'b100,adpsta=3'b101;
	//复位状态，学号流水灯状态，乘法输入状态，乘法结果显示状态，自动乘法器状态，自动乘法器显示状态
	reg [7:0]in1,in2,atoin1,atoin2,atoin3,atoin4;
	//乘法器输入1&2，自动乘法器乘数显示1&2，自动乘法器乘数显示3&4
	reg [15:0]out,atoout;//乘法结果和自动乘法结果
	reg en;//流水灯使能位
	reg flag1=0,flag2=0,flag3=0,flag4=0,flag5=0;//按键标志位
	reg [7:0]hung,melantha;//占位符00
	reg [9:0]folinic;//自动乘法器保持状态标志位
	/*****分频器*****/
	defparam exusiai.N=15;
	defparam exusiai.CLK_Freq=50000000;
	defparam exusiai.OUT_Freq=1000;
	frediv exusiai(.CLK_50M(clk),.nCR(rst_n),.CLK_Out(fre1k));
	defparam platinum.N=20;
	defparam platinum.CLK_Freq=50000000;
	defparam platinum.OUT_Freq=100;
	frediv platinum(.CLK_50M(clk),.nCR(rst_n),.CLK_Out(fre100));
	defparam texas.N=24;
	defparam texas.CLK_Freq=50000000;
	defparam texas.OUT_Freq=10;
	frediv texas(.CLK_50M(clk),.nCR(rst_n),.CLK_Out(fre10));
	// defparam amiya.N=18;
	// defparam amiya.CLK_Freq=50000000;
	// defparam amiya.OUT_Freq=500;
	// frediv amiya(.CLK_50M(clk),.nCR(rst_n),.CLK_Out(fre500));
	defparam cuora.N=26;
	defparam cuora.CLK_Freq=50000000;
	defparam cuora.OUT_Freq=2;
	frediv cuora(.CLK_50M(clk),.nCR(rst_n),.CLK_Out(fre2));
	/****************/
	/*****消抖器*****/
	debounce k1(krst,keys[0],fre100,rst_n);
	debounce k2(key1,keys[1],fre100,rst_n);
	debounce k3(key2,keys[2],fre100,rst_n);
	debounce k4(key3,keys[3],fre100,rst_n);
	debounce k5(key4,keys[4],fre100,rst_n);
	debounce k6(key5,keys[5],fre100,rst_n);
	debounce k7(key6,keys[6],fre100,rst_n);
	debounce k8(key7,keys[7],fre100,rst_n);
	/****************/
	/*****转时序*****/
	always@(posedge fre1k or negedge krst)
		if(!krst)
			crtsta<=rststa;
		else if(!key1||!key2||!key3||!key4)
			crtsta<=nxtsta;
		else if(!key5||folinic)//此处作用是当摁下key5或folinic为真时都能让自动乘法器改变状态
			crtsta<=nktsta;
	/****************/
	/*****摁按键*****/
	always@(posedge fre1k or negedge krst)
	//低电平进入，判断当前状态进行相应操作，后对flagx赋值1，没有按下则赋值为0
	//每一次1khz上升沿检测一次按键状态
	begin
		if(!krst)
		begin
			in1<=0;
			in2<=0;
			nxtsta<=rststa;
		end
		else 
		begin
			if(!key1)
			begin
				flag1<=1;
				if(!flag1)
				begin
					if(crtsta==rststa)
						nxtsta<=dpysta;
					else
						nxtsta<=rststa;
				end
			end
			else 
			begin
				flag1<=0;
			end
			if(!key2)
			begin
				flag2<=1;
				if(!flag2)
				begin
					if(crtsta==mulsta)
					in1<=in1+1;//key2摁下，乘数递增，摁一次加1
					nxtsta<=mdpsta;
				end
				else 
					nxtsta<=mulsta;
			end
			else
			begin
				flag2<=0;
			end
			if(!key3)
			begin
				flag3<=1;
				if(!flag3)
				begin
					if(crtsta==mulsta)
					in2<=in2+1;//key3摁下，乘数递增，摁一次加1
					hung<=4'h00;
					nxtsta<=mdpsta;
				end
				else 
					nxtsta<=mulsta;
			end
			else
			begin
				flag3<=0;
			end
			if(!key4)//key4摁下，求出结果
			begin
				flag4<=1;
				if(!flag4)
				begin
					if(crtsta==mdpsta)
					begin
						nxtsta<=atosta;
					end
					else
						nxtsta<=mdpsta;
				end
			end
			else
			begin
				flag4<=0;
			end
		end
	end
	always@(posedge fre2 or negedge key7)
	begin
		if(!key7)
		begin
			atoin1<=1;
			atoin2<=2;
			nktsta<=atosta;
			folinic<=0;
		end
		else
		begin
			if(key5)//此处为了不需要长按按键就能实现功能，因此去掉了！
			begin
				if(crtsta==atosta)
				begin
					atoin3<=atoin1;
					atoin4<=atoin2;
					atoin1<=atoin1+1;
					atoin2<=atoin2+1;//atoin3&atoin4的作用是避免乘法器出来的结果是上一次乘法的结果
					melantha<=4'h00;
					folinic<=1;//folinic的作用是在不按按键的情况下，为真时可以让crtsta在atosta和adpsta之间切换
					nktsta<=adpsta;
				end
				else
					nktsta<=atosta;
			end
			if(!key5)//此处作用是在自动乘法模式下，摁一下key5就能脱离，返回开头的学号流水灯模式
			begin
				flag5<=1;
				if(!flag5)
				begin
					if(crtsta==atosta||crtsta==adpsta)
					begin
						nktsta<=dpysta;
						folinic<=0;
					end
					else
						nktsta<=rststa;
				end
			end
			else
			begin
				flag5<=0;
			end
		end
	end
	_8bitmultclk poca(out,in1,in2,fre10,krst);
	_8bitmultclk beagle(atoout,atoin3,atoin4,fre10,key7);
	/*****数码管*****/
	always@(*)
	begin
		if(crtsta==dpysta)
		begin
			number<=24'h332002;
			en<=1;
		end
		else if(crtsta==mulsta)
		begin
			number<={in1,in2,hung};
			en<=0;
		end
		else if(crtsta==mdpsta)
		begin
			number<=out;
			en<=0;
		end
		else if(crtsta==atosta)
		begin
			number<={atoin1,atoin2,melantha};
			en<=0;
		end
		else if(crtsta==adpsta)
		begin
			number<=atoout;
		end
	end
	ledshow slience(en,fre10,krst,leds);
	displayhex magallan(fre1k,seg_leds,seg_nCS,krst,number);
endmodule
		
	