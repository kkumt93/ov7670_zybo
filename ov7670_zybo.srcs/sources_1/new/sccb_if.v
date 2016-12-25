
module sccb_if(
input clk_25,
input rst,
output sda,
output scl
);

parameter SendCnt = 8'd98;

parameter IdAddr = 8'h42;

parameter Start = 4'h0;
parameter WaitPowerOn = 4'h1;
parameter DataSet = 4'h2;
parameter DataSend = 4'h3;
parameter AddrAdd = 4'h4;
parameter Wait = 4'h5;
parameter End = 4'h6;

parameter TimerOn = 1'b1;
parameter TimerOff = 1'b0;

reg timer;
reg [9:0] div_clk;
reg [3:0] state;
reg [7:0] cnt;
reg [29:0] shift_reg;
reg [7:0] rom_addr;

wire scl_n;
wire [15:0] rom_data;
wire [29:0] send_data;

assign send_data = {2'b0,IdAddr,1'b1,rom_data[15:8],1'b1,rom_data[7:0],1'b1,1'b0};

//div clk genearte
always @(posedge clk_25 or posedge rst) begin
  if(rst) begin
    div_clk <= 10'h0;
  end else begin
    div_clk <= div_clk + 10'h1;
  end
end

//200kHz
assign scl_n = div_clk[7];

//STATE
always @(posedge scl_n or posedge rst) begin
  if(rst) begin
    state <= Start;
    timer <= TimerOff;
  end else if(state==Start) begin
    state <= WaitPowerOn;
    timer <= TimerOn;
  end else if(state==WaitPowerOn) begin
    if(cnt==SendCnt) begin
      state <= DataSet;
    end else begin
      timer <= TimerOff;
    end
  end else if(state==DataSet) begin
    state <= DataSend;
    timer <= TimerOn;
  end else if(state==DataSend) begin
    if(cnt==8'd28) begin
      state <= AddrAdd;
    end else begin
      timer <= TimerOff;
    end
  end else if(state==AddrAdd) begin
    if(rom_addr==8'd99) begin
      state <= End;
    end else begin
      state <= Wait;
      timer <= TimerOn;
    end
  end else if(state==Wait) begin
    if(cnt==8'h40) begin
        state <= DataSet;
    end else begin
      timer <= TimerOff;
    end
  end
end

//TIMER
always @(posedge scl_n or posedge rst) begin
  if(rst) begin
    cnt <= 8'h0;
  end else if(timer==TimerOn) begin
    cnt <= 8'h0;
  end else if(cnt==8'hff) begin
    cnt <= cnt;
  end else begin
    cnt <= cnt + 8'h1;
  end
end

//DATA SET
always @(posedge scl_n or posedge rst) begin
  if(rst) begin
    shift_reg <= 29'h0;
  end else if(state==DataSet) begin
    shift_reg <= send_data;
  end else if(state==DataSend)begin
    shift_reg <= {shift_reg[28:0],1'b0};
  end
end

//ADDRESS INCREMENT
always @(posedge scl_n or posedge rst) begin
  if(rst) begin
    rom_addr <= 8'h0;
  end else if(rom_addr==8'hff) begin
    rom_addr <= rom_addr;
  end else if(state==AddrAdd) begin
    rom_addr <= rom_addr + 8'h1;
  end
end


assign sda = (state==DataSend && (cnt < 8'd30)) ? shift_reg[29] : 1'b1;
assign scl = (state==DataSend && (8'd1 <= cnt) && (cnt < 8'd29)) ? ~scl_n : 1'b1;


sccb_rom sccb_rom_inst(
    .clk(scl_n),
    .rst(rst),
    .addr(rom_addr),
    .data(rom_data)
);


endmodule
