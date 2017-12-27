`timescale 1ns / 1ps

module	tb_debouncing;

reg					clk;
reg					rst;
reg					in;
wire				out;

debouncing u1(clk,rst,in,out);

always #5 clk = ~clk;

initial begin
	clk = 0; rst = 1; in = 1'b0;
	#16;  rst = 0; in = 1'b1;
	#3;  rst = 0; in = 1'b0;
	#3;  rst = 0; in = 1'b1;
	#3;  rst = 0; in = 1'b0;
	#3;  rst = 0; in = 1'b1;
	#3;  rst = 0; in = 1'b0;
	#3;  rst = 0; in = 1'b1;
	#30; rst = 0;in = 1'b0;
	#3;  rst = 0; in = 1'b1;
	#3;  rst = 0; in = 1'b0;
	#3;  rst = 0; in = 1'b1;
	#3;  rst = 0; in = 1'b0;
	#100; $stop;		
end

endmodule

/* 上面的有bug...

 
`timescale 1ns / 1ns

module  tb_debouncing;

reg         clk;
reg         rst;
reg         in;
wire        out;

debouncing u1(clk,rst,in,out);

always #5 clk = ~clk;

initial begin
  clk = 1'b0; 
        rst = 1'b1; in = 1'b0;
  #16   rst = 1'b0; in = 1'b1;
  #3    rst = 1'b0; in = 1'b0;
  #3    rst = 1'b0; in = 1'b1;
  #3    rst = 1'b0; in = 1'b0;
  #3    rst = 1'b0; in = 1'b1;
  #3    rst = 1'b0; in = 1'b0;
  #3    rst = 1'b0; in = 1'b1;
  #30   rst = 1'b0; in = 1'b0;
  #3    rst = 1'b0; in = 1'b1;
  #3    rst = 1'b0; in = 1'b0;
  #3    rst = 1'b0; in = 1'b1;
  #3    rst = 1'b0; in = 1'b0;
  #100  $finish;    
end

endmodule

*/
