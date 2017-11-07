module T_FF(Q, T, clk, rst, en);
output Q;
input  T, clk, rst, en;
reg    Q;
always @(negedge clk)
    if(rst) //reset
      Q <= 1'b0;
    else    
      if(!en) //enable
        Q <= (T) ? ~Q : Q;
      else    
        Q <= Q;
endmodule 
