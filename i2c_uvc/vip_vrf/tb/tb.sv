
module tb;
  import uvm_pkg::*;
  import top_test_pkg::*;

  // Clock signal
  parameter time CLK_PERIOD = 10ns;
  logic clk_i = 0;
  always #(CLK_PERIOD / 2) clk_i = ~clk_i;

  // Interface
  i2c_uvc_if i2c_master_if (clk_i);

  // Instantiation
  i2c_master dut (
      .clk_i(i2c_master_if.clk_i),
      .rst_i(i2c_master_if.rst_i),
      .din_i(i2c_master_if.din_i),
      .dvsr_i(i2c_master_if.dvsr_i),
      .cmd_i(i2c_master_if.cmd_i),
      .wr_i2c_i(i2c_master_if.wr_i2c_i),
      .scl_io(i2c_master_if.scl_io),
      .sda_io(i2c_master_if.sda_io),
      .ready_o(i2c_master_if.ready_o),
      .done_tick_o(i2c_master_if.done_tick_o),
      .ack_o(i2c_master_if.ack_o),
      .dout_o(i2c_master_if.dout_o)
  );

  initial begin
    //$timeformat(-9,  0, "ns", 10);
    $timeformat(-12, 0, "ps", 10);
    $fsdbDumpvars;
    uvm_config_db#(virtual i2c_uvc_if)::set(null, "uvm_test_top.env.i2c_agent", "vif",
                                            i2c_master_if);
    run_test();
  end

endmodule : tb
