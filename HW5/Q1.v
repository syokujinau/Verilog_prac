module debouncing(clk, rst, in, out);
input clk, rst, in;
output reg out;

reg [2:0] state, next_state;
parameter WAIT = 3'b000,
          h1   = 3'b001,
          h2   = 3'b010,
          h3   = 3'b011,
          l1   = 3'b100,
          l2   = 3'b101;

always@(posedge clk) begin 
    if(rst) state <= WAIT;
    else    state <= next_state;
end

always@(state or in) begin //excitation logic 
    case(state)
        WAIT: next_state = (in) ? h1 : WAIT;
        h1  : next_state = (in) ? h2 : WAIT;
        h2  : next_state = (in) ? h3 : WAIT;
        h3  : next_state = (in) ? h3 : l1  ;
        l1  : next_state = (in) ? h3 : l2  ;
        l2  : next_state = (in) ? h3 : WAIT;
        default: next_state = WAIT;
    endcase
end

always@(state) begin //output logic
    case(state)
        WAIT: out = 1'b0;
        h1  : out = 1'b0;
        h2  : out = 1'b0;
        h3  : out = 1'b1;
        l1  : out = 1'b1; 
        l2  : out = 1'b1; 
        default: out = 1'b0; 
    endcase
end

endmodule


/*testbench*/
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
