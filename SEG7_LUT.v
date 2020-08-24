module SEG7_LUT(oSEG, iDIG) ;
	input wire[3:0]iDIG; //二进制数或BCD输入
	output reg [7:0] oSEG;//7段码输出
	always@(iDIG)//BCD码输入→七段码输出
	begin//用case语句实现真值表
		case (iDIG)//gfedcba
		/****************  abcd_efgh*/
			4'h0: oSEG <= 8'b0000_0011;// 0
			4'h1: oSEG <= 8'b1001_1111;// 1		
			4'h2: oSEG <= 8'b0010_0101;// 2		
			4'h3: oSEG <= 8'b0000_1101;// 3		
			4'h4: oSEG <= 8'b1001_1001;// 4		
			4'h5: oSEG <= 8'b0100_1001;// 5		
			4'h6: oSEG <= 8'b0100_0001;// 6		
			4'h7: oSEG <= 8'b0001_1111;// 7		
			4'h8: oSEG <= 8'b0000_0001;// 8		
			4'h9: oSEG <= 8'b0000_1001;// 9		
			4'ha: oSEG <= 8'b0001_0001;// a		
			4'hb: oSEG <= 8'b1100_0001;// b		
			4'hc: oSEG <= 8'b0110_0011;// c		
			4'hd: oSEG <= 8'b1000_0101;// d		
			4'he: oSEG <= 8'b0110_0001;// E		
			4'hf: oSEG <= 8'b0111_0001;// F		
		endcase
	end
endmodule