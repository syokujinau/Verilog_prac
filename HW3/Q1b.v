module T_FF(Q, T, clk, en, rst);
output Q;
input  T, clk, en, rst;
reg    Q;
always @(posedge rst or negedge clk)
  if(rst)
    Q = 0;
  else
    if(!en) //enable
      Q <= (T) ? ~Q : Q;
    else    
      Q <= Q;
endmodule 