`timescale 1ns/1ns

module t;

reg Clock, D;
wire Q;

    D_FF m (.Clock(Clock), .D(D), .Q(Q));

    // Enter fixture code here
    initial
    begin
    #0
	    Clock   = 0;
       D = 0;

    #50
	    Clock   = 1;



    #50
	    Clock   = 0;
       D = 1;

    #50
	    Clock   = 1;



    #50
	    Clock   = 0;
       D = 1'bx;

    #50
	    Clock   = 1;



    #50
	    Clock   = 0;
       D = 0;

    #50
	    Clock   = 1;

    #50
	    Clock   = 0;
       D = 1'b?;

    #50
	    Clock   = 1;



    #50
	    Clock   = 0;
       D = 0;

    #50
	    Clock   = 1;



    #50
	    Clock      = 0;
    end

endmodule // t
