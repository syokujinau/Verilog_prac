/* test bench for design (a) */
module stimulus_q2;
reg [7:0] din_a;  	
reg [7:0] din_b;
wire [16:0] result;
reg clock;  

/* instantiate your design here */
multiply_and_accumulate  multiply_and_accumulate(.acc(result), .a(din_a), .b(din_b), .clk(clock));
/* clock signal generation */
initial clock = 1'b0;
always  #5 clock = ~clock;

/* stimulus waveforms */
initial begin
din_a = 8'h04;
din_b = 8'h03;
#10 
din_a = 8'h02;
din_b = 8'h06;
#10 
din_a = 8'h10;
din_b = 8'h02;
#10 
din_a = 8'h04;
din_b = 8'h06;
end
endmodule

