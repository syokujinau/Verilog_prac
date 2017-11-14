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
always@(data_in)
begin
    case(mode)
        `sl:
            data_out = data_in << size;
        `sr: 
            data_out = data_in >> size;
        `rl:
            while(size--)
            begin
                data_out = {data_in[6:0], data_in[7]};
            end
        `rr:
            while(size--)
            begin
                data_out = {data_in[7:1], data_in[0]};
            end 
    endcase
end

endmodule
