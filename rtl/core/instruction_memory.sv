module instruction_memory #(
    parameter int DEPTH = 512,
    // needs 2 more bits for byte address
    localparam int AddrWidth = $clog2(DEPTH) + 2
) (
    input logic [AddrWidth-1:0] address,
    output logic [31:0] instruction
);

  logic [31:0] memory[DEPTH];

  initial begin
    $readmemh("program.hex", memory);
  end

  // byte addr to word addr
  assign instruction = memory[address>>2];

endmodule
