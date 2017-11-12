module multiply_and_accumulate(acc, a, b, rst, clk);
output [16:0] acc;
input [7:0] a,b; 
input rst;
input clk;
/*declare local variables ra, rb, mpy and c here*/
reg [7:0] ra, rb;
reg [16:0] rc;
wire [15:0] mpy;
wire [16:0] c;
/*describe 3 registers with bahavioral modeling here*/
//using nonblocking assignment since the statements in begin-end block are trigger by the same event
always@(posedge clk)
begin
  if(rst)
  begin
    ra<=8'h0;
    rb<=8'h0;
    rc<=17'h0;
  end
  else
  begin
    ra<=a;
    rb<=b;
    rc<=c;
  end
end
/*describe multiplier and adder with data flow modeling here*/
//LHS must be wire type
assign mpy = ra * rb;
assign   c = mpy + rc[16:1];
assign acc = rc;
//maybe assign acc=c;(not sure)
endmodule 

