import riscv_pkg::*;

module risc_v (
    input logic clk,
    input logic reset
);

  // memory depth parameters
  localparam int ImemDepth = 512;
  localparam int DmemDepth = 512;
  localparam int ImemAddrWidth = $clog2(ImemDepth) + 2;
  localparam int DmemAddrWidth = $clog2(DmemDepth) + 2;

  // PC
  logic           [31:0] pc;
  logic           [31:0] pc_plus_4;
  logic           [31:0] pc_plus_imm;

  // instruction fetch
  logic           [31:0] instruction;

  // instruction decoder
  opcode_e               opcode;
  logic           [ 4:0] rd;
  logic           [ 2:0] funct3;
  logic           [ 4:0] rs1;
  logic           [ 4:0] rs2;
  logic           [ 6:0] funct7;

  // immediate
  logic           [31:0] immediate;

  // control signals
  logic                  reg_write_en;
  wb_sel_e               writeback_sel;
  alu_src_b_sel_e        alu_src_b_sel;
  alu_op_e               alu_op;
  logic                  mem_read;
  logic                  mem_write;
  branch_type_e          branch_type;
  logic                  jump_target_sel;
  logic                  branch_en;
  logic                  jump_en;

  // regfile
  logic           [31:0] rs1_data;
  logic           [31:0] rs2_data;
  logic           [31:0] reg_wr_data;

  // ALU
  logic           [31:0] alu_b;
  logic           [31:0] alu_result;

  // branch
  logic                  branch_taken;

  // data memory
  logic           [31:0] mem_rd_data;

  // datapath logic
  assign pc_plus_imm = pc + immediate;

  assign alu_b = alu_src_b_sel ? immediate : rs2_data;

  always_comb begin
    unique case (writeback_sel)
      WB_ALU_RESULT: reg_wr_data = alu_result;
      WB_MEMORY_DATA: reg_wr_data = mem_rd_data;
      WB_PC_PLUS_4: reg_wr_data = pc_plus_4;
      WB_IMM: reg_wr_data = immediate;
      WB_PC_PLUS_IMM: reg_wr_data = pc_plus_imm;
      WB_NONE: reg_wr_data = 32'd0;
    endcase
  end

  // modules

  program_counter program_counter_inst (
      .clk            (clk),
      .reset          (reset),
      .branch_en      (branch_en),
      .branch_taken   (branch_taken),
      .jump_en        (jump_en),
      .jump_target_sel(jump_target_sel),
      .pc_plus_imm    (pc_plus_imm),
      .alu_result     (alu_result),
      .pc             (pc),
      .pc_plus_4      (pc_plus_4)
  );

  instruction_memory #(
      .DEPTH(ImemDepth)
  ) instruction_memory_inst (
      .address    (pc[ImemAddrWidth-1:0]),
      .instruction(instruction)
  );

  instruction_decoder instruction_decoder_inst (
      .instruction(instruction),
      .opcode     (opcode),
      .rd         (rd),
      .funct3     (funct3),
      .rs1        (rs1),
      .rs2        (rs2),
      .funct7     (funct7)
  );

  immediate_generator immediate_generator_inst (
      .instruction(instruction),
      .immediate  (immediate)
  );

  control_unit control_unit_inst (
      .opcode         (opcode),
      .funct3         (funct3),
      .funct7         (funct7),
      .reg_write_en   (reg_write_en),
      .writeback_sel  (writeback_sel),
      .alu_src_b_sel  (alu_src_b_sel),
      .alu_op         (alu_op),
      .mem_read       (mem_read),
      .mem_write      (mem_write),
      .branch_type    (branch_type),
      .jump_target_sel(jump_target_sel),
      .branch_en      (branch_en),
      .jump_en        (jump_en)
  );

  regfile regfile_inst (
      .clk      (clk),
      .wr_e     (reg_write_en),
      .wr_data  (reg_wr_data),
      .wr_addr  (rd),
      .rd_addr1 (rs1),
      .rd_addr2 (rs2),
      .rd_data_1(rs1_data),
      .rd_data_2(rs2_data)
  );

  alu alu_inst (
      .a     (rs1_data),
      .b     (alu_b),
      .op    (alu_op),
      .result(alu_result)
  );

  branch_comparator branch_comparator_inst (
      .rs1_data    (rs1_data),
      .rs2_data    (rs2_data),
      .branch_type (branch_type),
      .branch_taken(branch_taken)
  );

  data_memory #(
      .DEPTH(DmemDepth)
  ) data_memory_inst (
      .clk    (clk),
      .wr_addr(alu_result[DmemAddrWidth-1:0]),
      .rd_addr(alu_result[DmemAddrWidth-1:0]),
      .wr_en  (mem_write),
      .wr_data(rs2_data),
      .rd_data(mem_rd_data)
  );

endmodule
