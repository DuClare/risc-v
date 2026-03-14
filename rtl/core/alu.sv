module alu
(
    input logic    [31:0] a,
    input logic    [31:0] b,
    input alu_op_e        op,
    output logic [31:0] result
);

import riscv_pkg::*;

  always_comb begin
    unique case (op)
      ALU_ADD:  result = a + b;
      ALU_SUB:  result = a - b;
      ALU_AND:  result = a & b;
      ALU_OR:   result = a | b;
      ALU_XOR:  result = a ^ b;
      ALU_SLL:  result = a << b[4:0];
      ALU_SRL:  result = a >> b[4:0];
      ALU_SRA:  result = $unsigned($signed(a) >>> b[4:0]);
      ALU_SLT:  result = {31'b0, $signed(a) < $signed(b)};
      ALU_SLTU: result = {31'b0, a < b};
      default:  result = '0;
    endcase
  end

endmodule
