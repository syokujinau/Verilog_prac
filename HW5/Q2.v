module ram1024X16(clk, addr, data, rw, cs);
input clk, rw, cs;
input [9:0] addr;
inout [15:0] data;
// addr[9:8]就能決定每個ram的cs為什麼還要input cs??
reg [15:0] ram0 [0:1023];
reg [15:0] ram1 [0:1023];
reg [15:0] ram2 [0:1023];
reg [15:0] ram3 [0:1023];
reg [15:0] dout;

//dataflow 
assign data = (!rw)&&(!cs) ? dout : 16'bzzzz_zzzz_zzzz_zzzz; 

//for read
always@(posedge clk, posedge rst) begin 
    case()
end


endmodule


/*testbench*/
`timescale 1ns / 1ns

module  tb_ram1024x16;

reg                 clk;
reg         [7:0]   din;
reg         [9:0]   addr;
reg                 rw;
reg                 cs;
wire        [7:0]   data;

ram1024X16 u1(clk, addr, data, rw, cs);

//assign data = (!rw)&&(!cs) ? 8'bzzzzzzzz : din;

always #5 clk = ~clk;

initial begin
    clk = 1'b0; 
         din = 8'd0;   addr = 10'd0;    rw = 1'b0; cs = 1'b1;  
    #43  din = 8'd168; addr = 10'd7;    rw = 1'b1; cs = 1'b0;
    #20  din = 8'd44;  addr = 10'd1000; rw = 1'b1; cs = 1'b0;
    #10  din = 8'd123; addr = 10'd19;   rw = 1'b0; cs = 1'b0; 
    #20  din = 8'd123; addr = 10'd7;    rw = 1'b0; cs = 1'b0;
    #10  din = 8'd77;  addr = 10'd700;  rw = 1'b1; cs = 1'b0;
    #10  din = 8'd66;  addr = 10'd1000; rw = 1'b0; cs = 1'b0;
    #10  din = 8'd66;  addr = 10'd400;  rw = 1'b1; cs = 1'b0;
    #10  din = 8'd66;  addr = 10'd700;  rw = 1'b0; cs = 1'b0;
    #10  din = 8'd66;  addr = 10'd400;  rw = 1'b0; cs = 1'b1;
    #10  $finish;   
end

endmodule
