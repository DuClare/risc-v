module regfile (
    input logic clk,
    input logic wr_e,
    input logic [31:0] wr_data,
    input logic [4:0] wr_addr,
    input logic [4:0] rd_addr1,
    input logic [4:0] rd_addr2,
    output logic [31:0] rd_data_1,
    output logic [31:0] rd_data_2
);

  logic [31:0] regs[32];

  // 1 Write
  always_ff @(posedge clk) begin
    if (wr_e & wr_addr != 0) regs[wr_addr] <= wr_data;
  end

  // 2 Reads and x0 = 0
  assign rd_data_1 = (rd_addr1 == 0) ? 32'd0 : regs[rd_addr1];
  assign rd_data_2 = (rd_addr2 == 0) ? 32'd0 : regs[rd_addr2];


endmodule
