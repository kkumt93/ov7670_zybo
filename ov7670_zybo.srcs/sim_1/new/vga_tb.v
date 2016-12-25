`timescale 1ns / 1ns

module vga_tb;

parameter step = 100;

reg clk;
reg rst;

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

wire       hactive;
wire       vactive;
wire [9:0] hactive_cnt;
wire [9:0] vactive_cnt;

reg div_clk;

always @(posedge clk or posedge rst) begin
    if(rst) begin
        div_clk <= 0;
    end else begin
        div_clk <= ~div_clk;
    end
end


wire [16:0] addrb;
wire [15:0] doutb;


blk_mem_gen_0 your_instance_name (
    .clka(clk),    // input wire clka
    .ena(1'b1),      // input wire ena
    .wea(wea),      // input wire [0 : 0] wea
    .addra(addra),  // input wire [16 : 0] addra
    .dina(dina),    // input wire [15 : 0] dina
    .clkb(clk),    // input wire clkb
    .enb(enb),      // input wire enb
    .addrb(addrb),  // input wire [16 : 0] addrb
    .doutb(doutb)  // output wire [15 : 0] doutb
);

vga_generator vga_generator_inst(
    .clk_25(clk),
    .rst(rst),
    .hsync(),
    .hactive(hactive),
    .vsync(),
    .vactive(vactive),
    .hactive_cnt(hactive_cnt),
    .vactive_cnt(vactive_cnt)
);

assign addrb = hactive_cnt[9:1] + 10'd320 * vactive_cnt[9:1];
assign enb = hactive & vactive;


endmodule
