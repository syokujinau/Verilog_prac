`define sl 2'b00
`define sr 2'b01
`define rl 2'b10
`define rr 2'b11

module barrel_shifter(
    data_in,
    mode,
    size,
    data_out
);
input [7:0] data_in;
/*
mode control, 
00 logic shift left, 
01 logic shift right,
10 rotate left,
11 rotate right
*/ 
input [1:0] mode;
/*the displacement size of the shift-rotate operation, 0~3 bits*/ 
input [1:0] size;
output [7:0] data_out;
reg [7:0] data_out;
always@(mode or size)  //不可以用data_in當作事件，要用會變化的訊號當事件
begin
    case(mode)
        `sl: data_out = data_in << size;
        `sr: data_out = data_in >> size;
        `rl: data_out = rotate(data_in, size, `rl);
        `rr: data_out = rotate(data_in, size, `rr);
        default: $display("ERROR"); 
    endcase
end

/*處理旋轉的函式*/
function [7:0] rotate(
    input [7:0] data, 
    input [1:0] size, //旋轉bit數
    input [1:0] mode  //哪種mode
);
reg [15:0] tmp;
begin
    if(mode == `rl)      
    begin
        tmp = {data, data} << size; //複製2倍寬，再左移
        rotate = tmp[15:8];  //取前1/2 bit，即為旋轉
    end 
    else if(mode == `rr) 
    begin
        tmp = {data, data} >> size;
        rotate = tmp[7:0];
    end 
end
endfunction
endmodule

/*test bench*/
module top2;
reg [7:0] din;
reg [1:0] m;
reg [1:0] s;
wire [7:0] dout; 
barrel_shifter barrel_shifter(
    din,
    m,
    s,
    dout
);
initial
begin
    // 0
    din = 8'h6b;
    {m, s} = 4'b0000;
    // 5
    #5 {m, s} = 4'b0010;
    #5 {m, s} = 4'b1001;
    #5 {m, s} = 4'b1011;
    #5 {m, s} = 4'b0101;
    #5 {m, s} = 4'b0110;
    #5 {m, s} = 4'b1111;
    #5 {m, s} = 4'b1100;
    #5 $finish;
end 
endmodule



