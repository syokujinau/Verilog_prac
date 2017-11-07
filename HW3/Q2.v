module multiply_and_accumulate(acc, a, b, clk);
input clk;
input [7:0] a,b;
output [16:0] acc;
/*declare local variables ra, rb, mpy and c here*/
reg [7:0] ra, rb;
reg [16:0] rc;
wire [15:0] mpy;
wire [16:0] c;
/*describe 3 registers with bahavioral modeling here*/
always@(posedge clk)
  begin
  ra<=a;
  rb<=b;
  rc<=c;
  end
/*describe multiplier and adder with data flow modeling here*/
assign mpy=ra*rb;
assign c=mpy+rc[16:1];
assign acc=rc;
//maybe assign acc=c;(not sure)
endmodule 
