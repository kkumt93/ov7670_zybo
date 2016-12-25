`timescale 1ns / 1ps

module cam_tb;

parameter step = 100;

reg clk;
reg rst;
reg [10:0] hcnt;
reg [10:0] vcnt;
wire [7:0]  data;

wire href;
wire vsync;

always begin
  #step clk = ~clk;
end

initial begin
    clk = 1'b0;
    rst = 1'b1;
    #(step*2);
    rst = 1'b0;
    #(step*5000000);
    $finish;
end

always @(posedge clk) begin
    if(rst) begin
        hcnt <= 11'd0;
    end else if(hcnt==11'd1567) begin
        hcnt <= 11'd0;
    end else begin
        hcnt <= hcnt + 11'd1;
    end
end

always @(posedge clk) begin
    if(rst) begin
        vcnt <= 11'd0;
    end else if(vcnt==11'd509) begin
        vcnt <= 11'd0;
    end else if(hcnt==11'd1567) begin
        vcnt <= vcnt + 11'd1;
    end
end

assign href  = (11'd0 <= hcnt && hcnt < 11'd1280 && 11'd20 <=vcnt && vcnt < 11'd500) ? 1'b1 : 1'b0;
assign vsync = (vcnt < 11'd3)  ? 1'b1 : 1'b0;

assign data  = (href && ~hcnt[0]) ? 8'hff : 8'h0;


rgb565_ctrl rgb565_ctrl_inst(
    .clk(clk),
    .rst(rst),
    .href(href),
    .vsync(vsync),
    .data_in(data),

    .data_en(),
    .data_out(),
    .hcnt_out(),
    .vcnt_out()
);


endmodule
