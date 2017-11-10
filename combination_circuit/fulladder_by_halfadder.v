module HalfAdder(
  input a,
  input b,
  output sum,
  output cout
);
  assign sum = a ^ b;
  assign cout = a & b;
endmodule 

module FullAdder(
  input a,
  input b,
  input cin,
  output sum,
  output cout
);
wire s0, c0, c1; //????
  HalfAdder HA0(a, b, s0, c0);
  HalfAdder HA1(cin, s0, sum, c1);
  or        OR(cout, c0, c1);
endmodule


`timescale 1ns/1ns
module test;
reg [2:0] IN;
wire sum, cout;
integer i;

  FullAdder FullAdder(IN[2], IN[1], IN[0], sum, cout);
  initial 
  begin
    IN = 0;
    for(i = 0; i < 8; i = i+1)
    begin 
      #100 IN = IN + 1;
    end
    $finish;
  end

endmodule 