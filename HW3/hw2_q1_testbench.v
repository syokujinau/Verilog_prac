/* test bench for design (a) */
module stimulus_a;
reg din;  	
reg reset;
wire q;

reg clock;  

/* instantiate your FF design here */
D_FF    D_FF(.q(q), .d(din), .clk(clock), .rst(reset));
/* clock signal generation */
initial clock = 1'b0;
always  #5 clock = ~clock;

/* stimulus waveforms */
initial begin
din = 1'b0;
reset = 1'b0;
#10 din = 1'b1;
#8 reset = 1'b1;
#10 din = 1'b0;
#5  reset = 1'b0;
#7  din = 1'b1;
end
endmodule



/* test bench for design (b) */
module stimulus_b;
reg enable;
reg clock;  
wire q;

/* instantiate your FF design here */
T_FF    T_FF(.Q(q), .T(0), .clk(clock), .rst(0), .en(enable));
/* clock signal generation */
initial clock = 1'b0;
always  #5 clock = ~clock;

/* stimulus waveforms */ 
initial begin
enable = 1'b1;
#25 enable = 1'b0;
#30 enable = 1'b1;
#20 enable = 1'b0;
end
endmodule




/* test bench for design (c) */
module stimulus_c;
reg set;
reg reset;
reg [7:0] din;
reg clock;  
wire [7:0] q;

/* instantiate your FF design here */
Reg_8bit    Reg_8bit(.reset(reset), .set(set), .clk(clock), .Reg_In(din), .Reg_Out(q));
/* clock signal generation */
initial clock = 1'b0;
always  #5 clock = ~clock;

/* stimulus waveforms */ 
initial begin
set = 1'b1;
reset = 1'b1;
din = 8'h00;
#10 reset = 1'b0;
#10 reset = 1'b1;
din = 8'hF0;
#10 set = 1'b0;
#10 din = 8'h11;
#10 din = 8'h22;
#5 din = 8'h33;
#5 din = 8'h44;
end
endmodule
