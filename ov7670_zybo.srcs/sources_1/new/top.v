module top (
input        clk_125,
input        rst_n,
input        cam_hsync,
input        cam_vsync,
input        pclk,
input [7:0]  cam_data,
output       xclk,
output       scl,
output       sda,
output       vga_vsync,
output       vga_hsync,
output [4:0] vga_r,
output [5:0] vga_g,
output [4:0] vga_b
);

wire  clk_50;

wire hactive;
wire vactive;

wire enb;
wire [16:0] addrb;
wire [15:0] doutb;
wire hsync;
wire vsync;
wire [9:0] hactive_cnt;
wire [9:0] vactive_cnt;


  clk_wiz_0 clk_wiz_0(
        .clk_in1(clk_125),
        .clk_out1(clk_50)
    );

    reg clk_25 = 0;

    always @(posedge clk_50) begin
        clk_25 = ~clk_25;
    end

    sccb_if sccb_if(
        .clk_25(clk_50),
        .rst(~rst_n),
        .sda(sda),
        .scl(scl)
    );

    wire [15:0] rgb_data;

    camera_controller camera_controller(
        .clk_50(clk_50),
        .pclk(pclk),
        .rst(~rst_n),
        .cam_data(cam_data),
        .cam_href(cam_hsync),
        .cam_vsync(cam_vsync),

        .xclk(xclk),
        .rgb_data(rgb_data),
        .vga_hsync(vga_hsync),
        .vga_vsync(vga_vsync)
    );

    assign {vga_r,vga_g,vga_b} = rgb_data;


endmodule
