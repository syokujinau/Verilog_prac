/*3bit counter head pointer*/
module head_ptr(
    input clk, 
    input en, 
    output reg [2:0] Q, 
    input rst
);
always@(posedge clk) begin
    if(rst) Q <= 3'b001;
    else begin
        if(en) Q <= Q + 1;
        else Q <= Q; //也可不assign 
    end 
end 
endmodule

/*3bit counter tail pointer*/
module tail_ptr(
    input clk, 
    input en, 
    output reg [2:0] Q, 
    input rst
);
always@(negedge clk) begin
    if(rst) Q <= 3'b001;
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
    output reg empty,
    input clear
);
always@(clear, head, tail) begin
    if(clear) {full, empty} = 2'b01;
    else begin
        if(head == tail)            {full, empty} = 2'b01;
        else if((tail + 1) == head) {full, empty} = 2'b10;
        else                        {full, empty} = 2'b00; 
    end 
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
    if(rw) begin //rw = 1 write
        mem[addr] = data_in;
        data_out = 8'bzzzz_zzzz;
    end 
    else begin //rw = 0 read
        data_out = mem[addr];
    end 
end 
endmodule

/*Insert_FSM*/
module Insert_FSM(
    input clk,
    input ins, 
    input full,
    input clear,
    output reg tail_en,
    output reg rw
);
reg state, next_state;
parameter A = 1'b0,
          B = 1'b1;
always@(posedge clk) begin
    if(clear) state <= 1'b0;
    else state <= next_state;
end 
always@(ins, full, state) begin
    case(state)
        A : next_state = ({ins, full} == 2'b10) ? B : A;
        B : next_state = ({ins, full} == 2'b10) ? B : A;
    endcase
end
always@(ins, full, state) begin
    case(state)
        A : {rw, tail_en} = ({ins, full} == 2'b10) ? 2'b11 : 2'b00;
        B : {rw, tail_en} = ({ins, full} == 2'b10) ? 2'b11 : 2'b00;
    endcase
end 
endmodule

/*Retrive_FSM*/
module Retrive_FSM(
    input clk,
    input ret, 
    input empty,
    input clear,
    output reg head_en,
    output reg rw
);
reg state, next_state;
parameter C = 1'b0,
          D = 1'b1;
always@(negedge clk) begin
    if(clear) state <= 1'b0;
    else state <= next_state;
end 
always@(ret, empty, state) begin
    case(state)
        C : next_state = ({ret, empty} == 2'b10) ? D : C;
        D : next_state = ({ret, empty} == 2'b10) ? D : C;
    endcase
end
always@(ret, empty, state) begin
    case(state)
        C : {rw, head_en} = ({ret, empty} == 2'b10) ? 2'b01 : 2'b00;
        D : {rw, head_en} = ({ret, empty} == 2'b10) ? 2'b01 : 2'b00;
    endcase
end 
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
wire h_en, t_en;
wire [2:0] h_addr, t_addr, in_addr;
wire in_full, in_empty; 
wire Ins_rw, Ret_rw, in_rw;

head_ptr head_ptr(clk, h_en, h_addr, clear);
tail_ptr tail_ptr(clk, t_en, t_addr, clear);
Flags Flags(h_addr, t_addr, in_full, in_empty, clear);
Circular_buffer Circular_buffer(data_in, data_out, in_addr, in_rw);
Insert_FSM Insert_FSM(clk, insert, in_full, clear, t_en, Ins_rw);
Retrive_FSM Retrive_FSM(clk, retrieve, in_empty, clear, h_en, Ret_rw);

assign in_addr = (in_rw) ? t_addr : h_addr;
assign in_rw = Ins_rw | Ret_rw;
assign full = in_full;
assign empty = in_empty;

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
        insert = 1'b1;     
        data_in = data_in + 8'd4;        
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
