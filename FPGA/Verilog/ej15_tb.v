`timescale 1ns/100ps

module ej15_tb();

reg d, e;
wire q, qNOT;

latchD latchD_tb(.D(d), .E(e), .Q(q), .Qnot(qNOT));

initial
begin
    #5;
    d = 1'b1;
    e = 1'b1;
    #10;
    d = 1'b0;
    e = 1'b0;
    #10;
    d  = 1'b0;
    e = 1'b1;
    #10;
    d  = 1'b1;
    e = 1'b0;
    #10;
    d  = 1'b1;
    e = 1'b1;
    #10;

    $finish;
end

endmodule
