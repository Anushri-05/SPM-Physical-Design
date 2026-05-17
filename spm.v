module spm(clk, rst, x, y, p);
    parameter size = 32;
    input clk, rst;
    input y;
    input[size-1:0] x;
    output p;

    wire[size-1:1] pp;
    wire rst_buf, y_buf;

    // Using Sky130 buffer cells explicitly
    sky130_fd_sc_hd__buf_8 rst_buf_cell (.A(rst), .X(rst_buf));
    sky130_fd_sc_hd__buf_8 y_buf_cell (.A(y), .X(y_buf));

    genvar i;

    CSADD csa0 (.clk(clk), .rst(rst_buf), .x(x[0]&y_buf), .y(pp[1]), .sum(p));
    generate for(i=1; i<size-1; i=i+1) begin
        CSADD csa (.clk(clk), .rst(rst_buf), .x(x[i]&y_buf), .y(pp[i+1]), .sum(pp[i]));
    end endgenerate
    TCMP tcmp (.clk(clk), .rst(rst_buf), .a(x[size-1]&y_buf), .s(pp[size-1]));

endmodule

module TCMP(clk, rst, a, s);
    input clk, rst;
    input a;
    output reg s;
    reg z;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            s <= 1'b0;
            z <= 1'b0;
        end else begin
            z <= a | z;
            s <= a ^ z;
        end
    end
endmodule

module CSADD(clk, rst, x, y, sum);
    input clk, rst;
    input x, y;
    output reg sum;
    reg sc;
    wire hsum1, hco1, hsum2, hco2;
    assign hsum1 = y ^ sc;
    assign hco1 = y & sc;
    assign hsum2 = x ^ hsum1;
    assign hco2 = x & hsum1;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sum <= 1'b0;
            sc <= 1'b0;
        end else begin
            sum <= hsum2;
            sc <= hco1 ^ hco2;
        end
    end
endmodule
