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
    output reg full,
    output reg empty
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

module FSM(
    input clk,
    input ret,
    input ins, 
    output h_en, 
    output t_en,
    output rw
);
//??
endmodule

module Queue(
    input clk,
    input clear,
    input [7:0] data_in,
    input insert,
    input retrieve,
    output [7:0] data_out,
    output full,
    output empty
);
//??
endmodule

/*testbench*/
`timescale 1ns / 1ns

module  tb_Queue;

reg     clk;
reg     clear;
reg     [7:0]data_in;
reg     insert;
reg     retrieve;

wire    [7:0]data_out;
wire    full;
wire    empty;

Queue u0(
.clk(clk),
.clear(clear),
.data_in(data_in),
.insert(insert),
.full(full),
.data_out(data_out),
.retrieve(retrieve),
.empty(empty)
);

always #5
    clk = ~clk;
    
integer i;
    
initial begin
    /*
        reset all
    */ 
    // 0ns
    clk = 1'b0;
    clear = 1'b1; 
    data_in = 1'b0;
    insert = 1'b0;    //{insert, retrieve} = 00
    retrieve = 1'b0;
    #20 // 20ns
    clear = 1'b0;
    #20 // 40ns
    /*  A.
        insert 10 of 8-bit Data
        retrieve 10 of 8-bit Data
        test : 1.insert
               2.retrieve
               3.full
               4.empty
    */
    @(posedge clk);
    for(i=0;i<10;i=i+1)begin  //insert 10 times 0 4 8 12 16 20 24 28 ...
        // {insert, retrieve} = 10
        insert = 1'b1;     //只間隔一個clk就insert??
        data_in = data_in + 8'd4;           //ok??
        @(posedge clk);
    end
    // {insert, retrieve} = 00
    insert = 1'b0;
    data_in = 1'b0;
    #20 // 60ns
    @(negedge clk);
    for(i=0;i<10;i=i+1)begin
        // {insert, retrieve} = 01
        retrieve = 1'b1;
        @(negedge clk);
    end
    // {insert, retrieve} = 00
    retrieve = 1'b0;
    #50 // 110ns
    /*  B.
        insert 6 of 8-bit Data
        retrieve 2 of 8-bit Data
        clear all
        retrieve 2 of 8-bit Data
        test : 1.insert
               2.retrieve
               3.clear
    */
    @(posedge clk);
    for(i=0;i<6;i=i+1)begin
        // {insert, retrieve} = 10
        insert = 1;
        data_in = data_in + 8'd4;
        @(posedge clk);
    end
    // {insert, retrieve} = 00
    insert = 1'b0;
    data_in = 1'b0;
    #20  // 130ns
    @(negedge clk);
    for(i=0;i<2;i=i+1)begin
        // {insert, retrieve} = 01
        retrieve = 1'b1;
        @(negedge clk);
    end
    // {insert, retrieve} = 00
    retrieve = 1'b0;
    #20  // 150ns
    clear = 1'b1;  //claer
    #20  // 170ns
    clear = 1'b0;
    @(negedge clk);
    for(i=0;i<2;i=i+1)begin
        // {insert, retrieve} = 01
        retrieve = 1'b1;
        @(negedge clk);
    end
    // {insert, retrieve} = 00
    retrieve = 1'b0;
    #50 // 220ns
    $finish;
end

endmodule
