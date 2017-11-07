module Reg_8bit(reset, set, clk, Reg_In, Reg_Out);
input reset, set, clk;
input  [7:0] Reg_In;
output [7:0] Reg_Out;
reg    [7:0] Reg_Out;
always @(negedge reset or posedge clk)
    if(!reset)
        Reg_Out = 8'b0000_0000;
    else
        if(clk && set) //reset = 1 and clk = 1
            Reg_Out = 8'b1111_1111;
        else
            Reg_Out = Reg_Out;
endmodule
