module universal_counter(
  data_in,
  load,
  claer,
  mode,
  enable,
  count,
  clk
);
input [3:0] data_in;
input load;
input claer;
input mode;
input enable;
output [3:0] count;
reg [3:0] count;

always@(posedge clk)
begin 
  
    if(claer)
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
