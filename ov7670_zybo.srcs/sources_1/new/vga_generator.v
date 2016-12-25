
module vga_generator(
    input clk_25,
    input rst,
    output reg hsync,
    output     hactive,
    output reg vsync,
    output reg vactive,
    output reg [9:0] hactive_cnt,
    output reg [9:0] vactive_cnt
    );

    //vga parameter & register
    parameter HMAX = 800;
    parameter HVALID = 640;
    parameter HPULSE = 96;
    parameter HBPORCH = 16;
    parameter VMAX = 512;
    parameter VVALID = 480;
    parameter VPULSE = 2;
    parameter VBPORCH = 10;

    reg [9:0] hcnt;
    reg [9:0] vcnt;
    reg       hactive_1T;
    reg       hactive_pre;

    wire hactive_pos;

    //hcnt
    always @(posedge clk_25 or posedge rst) begin
      if(rst == 1) begin
          hcnt <= 0;
      end else if(hcnt == HMAX -1) begin
          hcnt <= 0;
      end else begin
          hcnt <= hcnt + 1;
      end
    end

    //vcnt
    always @(posedge clk_25 or posedge rst) begin
      if(rst == 1) begin
          vcnt <= 0;
      end else if(vcnt == VMAX -1) begin
          vcnt <= 0;
      end else if(hcnt == HMAX -1) begin
          vcnt <= vcnt + 1;
      end
    end

    //hsync
    always @(posedge clk_25) begin
      if(hcnt < HPULSE) begin
          hsync <= 0;
      end else begin
          hsync <= 1;
      end
    end


    //vsync
    always @(posedge clk_25) begin
      if(vcnt < VPULSE) begin
          vsync <= 0;
      end else begin
          vsync <= 1;
      end
    end

    //hactive
    always @(posedge clk_25) begin
      if(hcnt < 144) begin
          hactive_pre <= 0;
          hactive_1T <= hactive_pre;
      end else if(hcnt > 783) begin
          hactive_pre <= 0;
          hactive_1T <= hactive_pre;
      end else begin
          hactive_pre <= 1;
          hactive_1T <= hactive_pre;
      end
    end

    assign hactive_pos = (hactive_pre && ~hactive_1T) ? 1'b1 : 1'b0;
    assign hactive = hactive_1T;

    //vactive
    always @(posedge clk_25) begin
      if(vcnt < 21) begin
          vactive <= 0;
      end else if(vcnt > 500) begin
          vactive <= 0;
      end else begin
          vactive <= 1;
      end
    end

    //vactive_cnt
    always @(posedge clk_25 or posedge rst) begin
      if(rst) begin
        vactive_cnt <= 10'h3ff;
      end else if(~vactive) begin
        vactive_cnt <= 10'h3ff;
      end else if (hactive_pos) begin
        vactive_cnt <= vactive_cnt + 10'h1;
      end
    end

    //hactive_cnt
    always @(posedge clk_25 or posedge rst) begin
      if(rst) begin
        hactive_cnt <= 10'h3ff;
      end else if(~hactive_pre) begin
        hactive_cnt <= 10'h3ff;
      end else if (hactive_pre)begin
        hactive_cnt <= hactive_cnt + 10'h1;
      end
    end


endmodule
