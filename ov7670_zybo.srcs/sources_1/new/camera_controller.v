
module camera_controller(
input         clk_50,
input         pclk,
input         rst,
input [7:0]   cam_data,
input         cam_href,
input         cam_vsync,

output        xclk,
output [15:0] rgb_data,
output        vga_hsync,
output        vga_vsync
);

reg clk_25;

always @(posedge clk_50 or posedge rst) begin
    if(rst) begin
        clk_25 <= 1'b0;
    end else begin
        clk_25 <= ~clk_25;
    end
end

assign xclk = clk_25;

wire        data_en;
wire [15:0] cam_data_out;
wire [9:0] cam_hcnt_out;
wire [9:0] cam_vcnt_out;

rgb565_ctrl rgb565_ctrl(
    .clk(pclk),
    .rst(rst),
    .href(cam_href),
    .vsync(cam_vsync),
    .data_in(cam_data),

    .data_en(data_en),
    .data_out(cam_data_out),
    .hcnt_out(cam_hcnt_out),
    .vcnt_out(cam_vcnt_out)
);

wire [16:0] addra;

assign addra = cam_hcnt_out[9:1] + cam_vcnt_out * 10'd320;

wire enb;
wire [16:0] addrb;
wire [15:0] doutb;

blk_mem_gen_0 blk_mem_gen_0(
    .clka(clk_50),    // input wire clka
    .ena(1'b1),      // input wire ena
    .wea(data_en),      // input wire [0 : 0] wea
    .addra(addra),  // input wire [16 : 0] addra
    .dina(cam_data_out),    // input wire [15 : 0] dina
    .clkb(clk_50),    // input wire clkb
    .enb(enb),      // input wire enb
    .addrb(addrb),  // input wire [16 : 0] addrb
    .doutb(doutb)  // output wire [15 : 0] doutb
);

wire hactive;
wire vactive;
wire [9:0] hactive_cnt;
wire [9:0] vactive_cnt;

vga_generator vga_generator(
    .clk_25(clk_25),
    .rst(rst),
    .hsync(vga_hsync),
    .hactive(hactive),
    .vsync(vga_vsync),
    .vactive(vactive),
    .hactive_cnt(hactive_cnt),
    .vactive_cnt(vactive_cnt)
);

assign addrb = hactive_cnt[9:1] + vactive_cnt[9:1] * 10'd320;
assign enb = hactive & vactive;
assign rgb_data = (enb) ? doutb : 16'h0;

endmodule