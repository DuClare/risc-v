module tb_risc_v;

  logic clk = 0;
  logic reset = 1;

  risc_v risc_v_inst (
      .clk  (clk),
      .reset(reset)
  );

  always #5 clk = ~clk;

  initial begin
    $dumpfile("tb_risc_v.vcd");
    $dumpvars(0, tb_risc_v);
    #20;
    reset = 0;
    @(posedge clk);
    #300;
    $display("x1 = %0d", risc_v_inst.regfile_inst.regs[1]);
    $display("x2 = %0d", risc_v_inst.regfile_inst.regs[2]);
    $display("x3 = %0d", risc_v_inst.regfile_inst.regs[3]);
    $display("x4 = %0d", risc_v_inst.regfile_inst.regs[4]);
    $display("x5 = %0d", risc_v_inst.regfile_inst.regs[5]);

    $finish;

  end

endmodule
