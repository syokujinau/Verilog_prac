/*定義各種運算*/
`define BitwiseOR   3'b000
`define BitwiseAND  3'b001
`define BitwiseXOR  3'b010
`define Negation    3'b011
`define Addition    3'b100
`define Increment   3'b101
`define Subtraction 3'b110
`define Decrement   3'b111
module alu8b(Y, C, Z, A, B, code);
input [7:0] A;
input [7:0] B;
input [2:0] code;
output [7:0] Y;
output Z,C;

reg signed [8:0] sub; //用於檢查減法overflow
reg [7:0] Y; 
reg Z,C;

always@(A, B, code)
begin
    /*依照opcode輸出運算結果*/
    case(code)
        `BitwiseOR  : Y = A | B;
        `BitwiseAND : Y = A & B;
        `BitwiseXOR : Y = A ^ B;
        `Negation   : Y = ~A;
        `Addition   : Y = A + B;
        `Increment  : Y = A + 1;
        `Subtraction: Y = A - B;
        `Decrement  : Y = A - 1;
        default: $display("ERROR");
    endcase

    /*設定旗標C、Y*/
    if(code[2] == 0) //Logical
    begin 
        C = 0;
        if(Y == 0) Z = 1;
        else       Z = 0;
    end
    else //Arithmetic
    begin
        // check flag C
        if(code == `Addition)  
        begin
          if(A + B > 255) C = 1;
          else            C = 0;
        end
        else if(code == `Increment)  
        begin
          if(A + 1 > 255) C = 1;
          else            C = 0;
        end
        else if(code == `Subtraction)  
        begin
          sub = A - B; //[註]減法需用有號數型態的變數才能判斷
          if(sub < 0)  C = 1;
          else         C = 0;
        end
        else if(code == `Decrement)    
        begin
          sub = A - 1;
          if(sub < 0)  C = 1;
          else         C = 0;
        end
         

        // check flag Z
        if(Y == 0) Z = 1;
        else       Z = 0;
    end 
end 
endmodule

/*test bench*/
module top4;
reg [7:0] A, B;
reg [2:0] code;
wire [7:0] Y;
wire Z, C;
/*Instantiate*/
alu8b alu8b(Y, C, Z, A, B, code);
initial
begin
    code = `BitwiseOR;
    A = 8'b0011_0101;
    B = 8'b1100_1010;
    #5
    code = `BitwiseAND;
    #5
    code = `BitwiseXOR;
    A = 8'b0100_1111;
    B = 8'b0101_0101;
    #5
    code = `Negation;
    #5
    code = `Addition;
    A = 8'd20;
    B = 8'd200;
    #5
    A = 8'd56;
    #5
    code = `Increment;
    A = 8'd0;
    #5
    code = `Subtraction;
    A = 8'd10;
    B = 8'd11;
    #5
    code = `Decrement;

    #5
    $finish;
end 
endmodule
