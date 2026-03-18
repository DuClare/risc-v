import riscv_pkg::*;

module immediate_generator (
    input  logic [31:0] instruction,
    output logic [31:0] immediate
);

  opcode_e opcode;
  assign opcode = opcode_e'(instruction[6:0]);

  always_comb begin
    immediate = 32'd0;

    unique case (opcode)
      // I-type
      OP_IMM, LOAD, JALR: immediate = {{20{instruction[31]}}, instruction[31:20]};

      // S-type
      STORE: immediate = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};

      // B-type
      BRANCH:
      immediate = {
        {19{instruction[31]}},
        instruction[31],
        instruction[7],
        instruction[30:25],
        instruction[11:8],
        1'b0
      };

      // U-type
      LUI, AUIPC: immediate = {instruction[31:12], 12'b0};

      // J-type
      JAL:
      immediate = {
        {11{instruction[31]}},
        instruction[31],
        instruction[19:12],
        instruction[20],
        instruction[30:21],
        1'b0
      };

      // R-type, no immediate
      OP: immediate = 32'd0;
    endcase
  end

endmodule
