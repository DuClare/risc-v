package riscv_pkg;

  typedef enum logic [3:0] {
    ALU_ADD  = 4'h0,
    ALU_SUB  = 4'h1,
    ALU_AND  = 4'h2,
    ALU_OR   = 4'h3,
    ALU_XOR  = 4'h4,
    ALU_SLL  = 4'h5,
    ALU_SRL  = 4'h6,
    ALU_SRA  = 4'h7,
    ALU_SLT  = 4'h8,
    ALU_SLTU = 4'h9
  } alu_op_e;

  typedef enum logic [6:0] {
    OP_IMM = 7'b0010011,  // I-type arithmetic
    LOAD   = 7'b0000011,  // I-type loads
    STORE  = 7'b0100011,  // S-type
    BRANCH = 7'b1100011,  // B-type
    LUI    = 7'b0110111,  // U-type
    AUIPC  = 7'b0010111,  // U-type
    JAL    = 7'b1101111,  // J-type
    JALR   = 7'b1100111,  // I-type jump
    OP     = 7'b0110011   // R-type
  } opcode_e;

endpackage
