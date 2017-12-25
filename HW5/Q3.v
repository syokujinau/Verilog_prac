/*3bit counter for head & tail pointer*/
module Counter_3bit(
    input clk, 
    input en, 
    output reg [2:0] Q, 
    input rst
);
always@(negedge clk) begin
    if(rst) Q <= 3'b000;
    else begin
        if(en) Q <= Q + 1;
        else Q <= Q; //也可不assign 
    end 
end 
endmodule

/*reg for full & empty flag*/
module Flags(
    input [2:0] head,
    input [2:0] tail,
    output full,
    output empty
);
always@(head, tail) begin 
    if(head == tail) {full, empty} = 2'b01;
    else if((tail + 1) == head) {full, empty} = 2'b10;
    else {full, empty} = 2'b00;
end
endmodule

/*Circular buffer for Queue storage*/
module Circular_buffer(
    input [7:0] data_in,
    output reg [7:0] data_out,
    input [2:0] addr, //for head or tail
    input rw //rw = 0 (read); rw = 1 (write)
);
reg [7:0] mem [0:7];
always@(rw, addr) begin
    if(rw) begin //write
        mem[addr] = data_in;
        data_out = 8'bzzzz_zzzz;
    end 
    else begin //read
        data_out = mem[addr];
    end 
end 
endmodule
