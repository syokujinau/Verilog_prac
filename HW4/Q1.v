module universal_counter(
  data_in,
  load,
  clear,
  mode, 
  enable,
  count,
  clk
);
input [3:0] data_in;
input load;
input clear;
input mode; 
input enable;
input clk;
output [3:0] count;
reg [3:0] count;

always@(posedge clk)
begin 
  
    if(clear)
      count <= 4'b0;
    else 
    begin
      if(load)
        count <= data_in;
      else
        if(enable) 
        begin
          if(mode)
            count <= count + 1;
          else
            count <= count - 1;
        end          
        else
          count <= count;
    end

end

endmodule

`timescale 1ns/1ns
module top1;
reg [3:0] data_in;
reg clear;
reg load;
reg enable;
reg mode; 
reg clk;
wire [3:0] count;


universal_counter universal_counter(
  data_in,
  load,
  clear,
  mode, 
  enable,
  count,
  clk
);

initial clk = 1'b1;
always #10 clk = ~clk;

initial 
begin
  //{clear, load, enable, mode} = 4'b1000;
  //data_in = 4'd0;
  #10
  {clear, load, enable, mode} = 4'b0011;
  data_in = 4'd0;
  #20 //1
  {clear, load, enable, mode} = 4'b0111;
  data_in = 4'd6;
  repeat(5) //2~6
  begin
    #20
    {clear, load, enable, mode} = 4'b0011;
    data_in = 4'd0;
  end 
  repeat(3) //7~9
  begin
    #20
    {clear, load, enable, mode} = 4'b0001;
    data_in = 4'd0;
  end 
  repeat(5) //10~14
  begin
    #20
    {clear, load, enable, mode} = 4'b0010;
    data_in = 4'd0;
  end 
  #20 //15
  {clear, load, enable, mode} = 4'b1110;
  data_in = 4'd8;
  repeat(8)
  begin //16~23
    #20  
    {clear, load, enable, mode} = 4'b0010;
    data_in = 4'd8;
  end
  #20 //24
  {clear, load, enable, mode} = 4'b1011;
  data_in = 4'd8;
  repeat(5) //25~29
  begin
    #20  
    {clear, load, enable, mode} = 4'b0011;
    data_in = 4'd4;
  end
  #20  //30
  {clear, load, enable, mode} = 4'b0001;
  data_in = 4'd4;

  #30 $finish;

end  
endmodule
