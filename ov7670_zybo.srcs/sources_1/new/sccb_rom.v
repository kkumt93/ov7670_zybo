module sccb_rom(
input             clk,
input             rst,
input       [7:0] addr,
output reg [15:0]data 
);

always @(posedge clk or posedge rst) begin
    if(rst) begin
        data <= 16'h0;
    end else begin
        case(addr)
            //send num : data <= 16bit {address,data}
            8'd0 : data <= 16'h1280;   //register reset command
            8'd1 : data <= 16'hXXXX;
            8'd2 : data <= 16'hXXXX;
            //
            //“r’†È—ª
            //
            8'd96 : data <= 16'hXXXX;
            8'd97 : data <= 16'hXXXX;
            8'd98 : data <= 16'hXXXX;
            default : data <= 16'hXXXX;
        endcase
    end
end

endmodule