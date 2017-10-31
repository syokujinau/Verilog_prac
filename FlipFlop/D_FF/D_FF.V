// D_FF.V, 最簡單的 D 型正反器, 直接將 D 傳入 Q
module  D_FF(Clock, D, Q);
input    Clock, D;
output   Q;
reg      Q;

  always @(posedge Clock)
  begin
    Q = D;  // 直接將 D 傳入 Q
  end
endmodule

