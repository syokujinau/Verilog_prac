`timescale 1ns / 1ps

module	tb_Queue;

reg		clk;
reg		clear;
reg		[7:0]data_in;
reg		insert;
reg		retrieve;

wire	[7:0]data_out;
wire	full;
wire	empty;

Queue u0(
.clk(clk),
.clear(clear),
.data_in(data_in),
.insert(insert),
.full(full),
.data_out(data_out),
.retrieve(retrieve),
.empty(empty)
);

always #5
	clk = !clk;
	
integer i;
	
initial begin
	/*
		reset all
	*/
	clk = 0;
	clear = 1;
	data_in = 0;
	insert = 0;
	retrieve = 0;
	#20
	clear = 0;
	#20
	/*	A.
		insert 10 of 8-bit Data
		retrieve 10 of 8-bit Data
		test : 1.insert
			   2.retrieve
			   3.full
			   4.empty
	*/
	@(posedge clk);
	for(i=0;i<10;i=i+1)begin
		insert = 1;
		data_in = data_in + 4;
		@(posedge clk);
	end
	insert = 0;
	data_in = 0;
	#20
	@(negedge clk);
	for(i=0;i<10;i=i+1)begin
		retrieve = 1;
		@(negedge clk);
	end
	retrieve = 0;
	#50
	/*	B.
		insert 6 of 8-bit Data
		retrieve 2 of 8-bit Data
		clear all
		retrieve 2 of 8-bit Data
		test : 1.insert
			   2.retrieve
			   3.clear
	*/
	@(posedge clk);
	for(i=0;i<6;i=i+1)begin
		insert = 1;
		data_in = data_in + 4;
		@(posedge clk);
	end
	insert = 0;
	data_in = 0;
	#20
	@(negedge clk);
	for(i=0;i<2;i=i+1)begin
		retrieve = 1;
		@(negedge clk);
	end
	retrieve = 0;
	#20
	clear = 1;
	#20
	clear = 0;
	@(negedge clk);
	for(i=0;i<2;i=i+1)begin
		retrieve = 1;
		@(negedge clk);
	end
	retrieve = 0;
	#50
	$stop;
end

endmodule