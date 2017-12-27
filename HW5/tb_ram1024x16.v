`timescale 1ns / 1ps

module	tb_ram1024x16;

reg					clk;
reg			[7:0]	din;
reg			[9:0]	addr;
reg					rw;
reg					cs;
wire		       [7:0]	data;

ram1024X16 u1(clk,addr,data,rw,cs);

assign data = (!rw)&&(!cs) ? 8'bzzzzzzzz : din;

always #5 clk = ~clk;

initial begin
	clk = 0; din = 8'd0; addr = 10'd0; rw = 1'b0; cs = 1'b1;
	#43; din = 8'd168; addr = 10'd7; rw = 1'b1; cs = 1'b0;
	#20; din = 8'd44; addr = 10'd1000; rw = 1'b1; cs = 1'b0;
	#10; din = 8'd123; addr = 10'd19; rw = 1'b0; cs = 1'b0; 
	#20; din = 8'd123; addr = 10'd7; rw = 1'b0; cs = 1'b0;
	#10; din = 8'd77; addr = 10'd700; rw = 1'b1; cs = 1'b0;
	#10; din = 8'd66; addr = 10'd1000; rw = 1'b0; cs = 1'b0;
	#10; din = 8'd66; addr = 10'd400; rw = 1'b1; cs = 1'b0;
	#10; din = 8'd66; addr = 10'd700; rw = 1'b0; cs = 1'b0;
	#10; din = 8'd66; addr = 10'd400; rw = 1'b0; cs = 1'b1;
	#10; $finish;	
end

endmodule
