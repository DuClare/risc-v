import riscv_pkg::*;

module branch_comparator (
    input logic [31:0] rs1_data,
    input logic [31:0] rs2_data,
    input branch_type_e branch_type,
    output logic branch_taken
);

  always_comb begin
    case (branch_type)
      BRANCH_BEQ:  branch_taken = (rs1_data == rs2_data);
      BRANCH_BNE:  branch_taken = (rs1_data != rs2_data);
      BRANCH_BLT:  branch_taken = ($signed(rs1_data) < $signed(rs2_data));
      BRANCH_BGE:  branch_taken = ($signed(rs1_data) >= $signed(rs2_data));
      BRANCH_BLTU: branch_taken = (rs1_data < rs2_data);
      BRANCH_BGEU: branch_taken = (rs1_data >= rs2_data);
      default:     branch_taken = 0;
    endcase
  end

endmodule
