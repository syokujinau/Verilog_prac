/*
4bit comparator
輸入: 4bit A， 4bit B
輸出: 大於、等於、小於
*/
module comp4b(data_a, data_b, gt, eq, lt);
input [3:0] data_a, data_b;
output gt, eq, lt;
reg gt, eq, lt;
always@(data_a, data_b)
begin
    if(data_a > data_b)      {gt, eq, lt} = 3'b100;
    else if(data_a < data_b) {gt, eq, lt} = 3'b001;
    else                     {gt, eq, lt} = 3'b010;
end 
endmodule

/*
結合4個4bit comparator，比較16bit大小關係
*/
module seg_comp(gt, eq, lt, A_gt_B, A_eq_B, A_lt_B);
input [3:0] gt;
input [3:0] eq;
input [3:0] lt;
output A_gt_B, A_eq_B, A_lt_B;
reg A_gt_B, A_eq_B, A_lt_B;
always@(gt, eq, lt)
begin
    //比較MSB的大小，若相等則比較下一個bit
    if(gt[3] == 1)      {A_gt_B, A_eq_B, A_lt_B} = 3'b100;
    else if(lt[3] == 1) {A_gt_B, A_eq_B, A_lt_B} = 3'b001;
    else //bit3 is equal, check bit2
    begin
        if(gt[2] == 1)      {A_gt_B, A_eq_B, A_lt_B} = 3'b100;
        else if(lt[2] == 1) {A_gt_B, A_eq_B, A_lt_B} = 3'b001;
        else //bit2 is equal, check bit1
        begin
            if(gt[1] == 1)      {A_gt_B, A_eq_B, A_lt_B} = 3'b100;
            else if(lt[1] == 1) {A_gt_B, A_eq_B, A_lt_B} = 3'b001;
            else //bit1 is equal, check bit0
            begin
                if(gt[0] == 1)      {A_gt_B, A_eq_B, A_lt_B} = 3'b100;
                else if(lt[0] == 1) {A_gt_B, A_eq_B, A_lt_B} = 3'b001;
                else // all equal A_eq_B = 1
                    {A_gt_B, A_eq_B, A_lt_B} = 3'b010;
            end 
        end 
    end
end
endmodule

/*test bench*/
module top3;
reg [15:0] A;
reg [15:0] B;
wire A_gt_B, A_eq_B, A_lt_B;
/*內部接線*/
wire [3:0] gt;
wire [3:0] eq;
wire [3:0] lt;
/*Instantiate*/
comp4b c3(A[15:12], B[15:12], gt[3], eq[3], lt[3]),
       c2(A[11: 8], B[11: 8], gt[2], eq[2], lt[2]),
       c1(A[ 7: 4], B[ 7: 4], gt[1], eq[1], lt[1]),
       c0(A[ 3: 0], B[ 3: 0], gt[0], eq[0], lt[0]);
seg_comp seg_comp(gt[3:0], eq[3:0], lt[3:0], A_gt_B, A_eq_B, A_lt_B);
initial 
begin
    A = 16'h04F8; //A = 0000_0100_1111_1000
    B = 16'h04F7; //B = 0000_0100_1111_0111  , A_gt_B
    #10           //A = 0000_0100_1111_1000
    B = 16'h04FA; //B = 0000_0100_1111_1010  , A_lt_B
    #10           //A = 0000_0100_1111_1010
    A = 16'h04FA; //B = 0000_0100_1111_1010  , A_eq_B
    #10           //A = 0000_0100_1111_1010
    B = 16'h24FA; //B = 0010_0100_1111_1010  , A_lt_B
    #10
    $finish;

end
endmodule


