module ram1024X16(clk, addr, data, rw, cs);
input clk, rw, cs;
input [9:0] addr;
inout [15:0] data;
 
reg [15:0] ram0 [0:1023];
reg [15:0] ram1 [0:1023];
reg [15:0] ram2 [0:1023];
reg [15:0] ram3 [0:1023];
reg [15:0] dout;

//dataflow 
assign data = (!rw)&&(!cs) ? dout : 16'bzzzz_zzzz_zzzz_zzzz; 

// read
always@(posedge clk) begin 
    // read
    if(!rw) begin
        case(addr[9:8])
            2'b00 : dout <= ram0[addr[7:0]]; 
            2'b01 : dout <= ram1[addr[7:0]];
            2'b10 : dout <= ram2[addr[7:0]];
            2'b11 : dout <= ram3[addr[7:0]];
            default : $display("error");
        endcase
        $display("%t : reading ram%d[%d] = %d, cs = %d", $time, addr[9:8], addr[7:0], dout, cs);
    end
    //write
    else begin
        case(addr[9:8])
            2'b00 : ram0[addr[7:0]] <= data;
            2'b01 : ram1[addr[7:0]] <= data;
            2'b10 : ram2[addr[7:0]] <= data;
            2'b11 : ram3[addr[7:0]] <= data;
            default : $display("error");
        endcase 
        $display("%t : writing ram%d[%d] <= %d, cs = %d", $time,  addr[9:8], addr[7:0], data, cs);
    end
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

assign data = (!rw)&&(!cs) ? 8'bzzzzzzzz : din;

always #5 clk = ~clk;

initial begin
    clk = 1'b0; 
         din = 8'd0;   addr = 10'd0;    rw = 1'b0; cs = 1'b1;  //read
    #43  din = 8'd168; addr = 10'd7;    rw = 1'b1; cs = 1'b0;  //write
    #20  din = 8'd44;  addr = 10'd1000; rw = 1'b1; cs = 1'b0;  //write
    #10  din = 8'd123; addr = 10'd19;   rw = 1'b0; cs = 1'b0;  //read
    #20  din = 8'd123; addr = 10'd7;    rw = 1'b0; cs = 1'b0;  //read
    #10  din = 8'd77;  addr = 10'd700;  rw = 1'b1; cs = 1'b0;  //write
    #10  din = 8'd66;  addr = 10'd1000; rw = 1'b0; cs = 1'b0;  //read
    #10  din = 8'd66;  addr = 10'd400;  rw = 1'b1; cs = 1'b0;  //write
    #10  din = 8'd66;  addr = 10'd700;  rw = 1'b0; cs = 1'b0;  //read
    #10  din = 8'd66;  addr = 10'd400;  rw = 1'b0; cs = 1'b1;  //read
    #10  $finish;   
end

endmodule
