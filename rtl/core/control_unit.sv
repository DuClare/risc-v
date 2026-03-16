import riscv_pkg::*;

module control_unit (
    // instruction decode
    input opcode_e opcode,
    input logic [2:0] funct3,
    input logic [6:0] funct7,
    // register
    output logic reg_write_en,
    // writeback type
    output wb_sel_e writeback_sel,
    // alu control
    output alu_src_b_sel_e alu_src_b_sel,
    output alu_op_e alu_op,
    // memory control
    output logic mem_read,
    output logic mem_write,
    // branch and jump control
    output branch_type_e branch_type,
    output logic jump_target_sel,  // 0 = PC+imm (JAL), 1 = ALU result (JALR)
    output logic branch_en,
    output logic jump_en
);

  always_comb begin
    // Defaults
    // No write to registers
    writeback_sel = WB_NONE;
    reg_write_en = 0;
    // Alu src B RS2
    alu_src_b_sel = ALU_SRC_B_RS2;
    // Alu ADD
    alu_op = ALU_ADD;
    // No memory R/W
    mem_read = 0;
    mem_write = 0;
    // No branch / jump
    branch_type = BRANCH_BEQ;
    branch_en = 0;
    jump_en = 0;
    jump_target_sel = 0;

    unique case (opcode)

      OP: begin
        reg_write_en  = 1;
        writeback_sel = WB_ALU_RESULT;
        unique case (funct3)
          3'd0: begin
            if (funct7 == 7'h0) alu_op = ALU_ADD;
            else alu_op = ALU_SUB;
          end
          3'd1: alu_op = ALU_SLL;
          3'd2: alu_op = ALU_SLT;
          3'd3: alu_op = ALU_SLTU;
          3'd4: alu_op = ALU_XOR;
          3'd5: begin
            if (funct7 == 7'h0) alu_op = ALU_SRL;
            else alu_op = ALU_SRA;
          end
          3'd6: alu_op = ALU_OR;
          3'd7: alu_op = ALU_AND;
        endcase
      end

      OP_IMM: begin
        reg_write_en  = 1;
        alu_src_b_sel = ALU_SRC_B_IMM;
        writeback_sel = WB_ALU_RESULT;
        unique case (funct3)
          3'd0: alu_op = ALU_ADD;
          3'd1: alu_op = ALU_SLL;
          3'd2: alu_op = ALU_SLT;
          3'd3: alu_op = ALU_SLTU;
          3'd4: alu_op = ALU_XOR;
          3'd5: begin
            if (funct7 == 7'h0) alu_op = ALU_SRL;
            else alu_op = ALU_SRA;
          end
          3'd6: alu_op = ALU_OR;
          3'd7: alu_op = ALU_AND;
        endcase
      end

      LOAD: begin
        // Write to a register
        reg_write_en = 1;
        writeback_sel = WB_MEMORY_DATA;
        // rs1+IMM
        alu_op = ALU_ADD;
        alu_src_b_sel = ALU_SRC_B_IMM;
        // Read memory
        mem_read = 1;
      end

      STORE: begin
        // rs1+IMM
        alu_op = ALU_ADD;
        alu_src_b_sel = ALU_SRC_B_IMM;
        // Store
        mem_write = 1;
      end


      BRANCH: begin
        // Compare rs1 and rs2
        alu_op = ALU_SUB;
        alu_src_b_sel = ALU_SRC_B_RS2;
        // Branch
        branch_type = branch_type_e'(funct3);  // match the encodings of funct3
        branch_en = 1;
        jump_en = 0;
      end

      LUI: begin
        // Write to a register
        reg_write_en  = 1;
        writeback_sel = WB_IMM;
      end

      AUIPC: begin
        // Write to a register
        reg_write_en  = 1;
        writeback_sel = WB_PC_PLUS_IMM;
      end


      JAL: begin
        // Write to a register
        reg_write_en = 1;
        writeback_sel = WB_PC_PLUS_4;
        // Jump
        jump_en = 1;
        jump_target_sel = 0;
      end

      // rs1 + imm
      JALR: begin
        // Write to a register
        reg_write_en = 1;
        writeback_sel = WB_PC_PLUS_4;
        // rs1 + imm
        alu_op = ALU_ADD;
        alu_src_b_sel = ALU_SRC_B_IMM;
        // Jump
        jump_en = 1;
        jump_target_sel = 1;
      end
    endcase

  end

endmodule
