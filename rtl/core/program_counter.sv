module program_counter (
    input  logic        clk,
    input  logic        reset,
    input  logic        branch_en,
    input  logic        branch_taken,
    input  logic        jump_en,
    input  logic        jump_target_sel,
    input  logic [31:0] pc_plus_imm,
    input  logic [31:0] alu_result,
    output logic [31:0] pc,
    output logic [31:0] pc_plus_4
);

  assign pc_plus_4 = pc + 32'd4;

  always_ff @(posedge clk or posedge reset) begin
    if (reset) pc <= 32'd0;
    else if (jump_en && jump_target_sel) pc <= alu_result;  // JALR
    else if (jump_en || (branch_en && branch_taken)) pc <= pc_plus_imm;  // JAL or branch taken
    else pc <= pc_plus_4;
  end

endmodule
