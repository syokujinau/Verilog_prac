// D_FF.V, ��²�檺 D �����Ͼ�, �����N D �ǤJ Q
module  D_FF(Clock, D, Q);
input    Clock, D;
output   Q;
reg      Q;

  always @(posedge Clock)
  begin
    Q = D;  // �����N D �ǤJ Q
  end
endmodule
