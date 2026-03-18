module data_memory #(
    parameter int DEPTH = 512,
    // needs 2 more bits for byte address
    localparam int AddrWidth = $clog2(DEPTH) + 2
) (
    input logic clk,
    // 2 ports. not needed for a single cycle design, but for readability
    input logic [AddrWidth-1:0] wr_addr,
    input logic [AddrWidth-1:0] rd_addr,
    input logic wr_en,
    input logic [31:0] wr_data,
    output logic [31:0] rd_data
);

  logic [31:0] memory[DEPTH];

  initial begin
    for (int i = 0; i < DEPTH; i++) begin
      memory[i] = 32'd0;
    end
  end

  always_ff @(posedge clk) begin
    if (wr_en) begin
      memory[wr_addr>>2] <= wr_data;
    end
  end

  always_comb begin
    rd_data = memory[rd_addr>>2];
  end


endmodule
