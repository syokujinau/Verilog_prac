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
