module tb;
  import uvm_pkg::*;
  import top_test_pkg::*;

  // Clock generator
  logic clk;
  always #5 clk = ~clk;

  initial begin
    clk = 0;
  end

  gpio_uvc_if port_a_if(clk);
  gpio_uvc_if port_b_if(clk);
  gpio_uvc_if port_c_if(clk);
  gpio_uvc_if port_rst_if(clk);

  localparam WIDTH = 8;

  adder dut (
    .clk(port_a_if.clk),
    .rst(port_rst_if.gpio_pin[0]),
    .A(port_a_if.gpio_pin[WIDTH-1:0]),
    .B(port_b_if.gpio_pin[WIDTH-1:0]),
    .C(port_c_if.gpio_pin_passive[WIDTH-1:0])
  );
  
  initial begin
    $timeformat(-9, 0, "ns", 10);
    $fsdbDumpvars;
    uvm_config_db #(virtual gpio_uvc_if)::set(null, "uvm_test_top.env.port_a_agent", "vif", port_a_if);
    uvm_config_db #(virtual gpio_uvc_if)::set(null, "uvm_test_top.env.port_b_agent", "vif", port_b_if);
    uvm_config_db #(virtual gpio_uvc_if)::set(null, "uvm_test_top.env.port_c_agent", "vif", port_c_if);
    uvm_config_db #(virtual gpio_uvc_if)::set(null, "uvm_test_top.env.port_rst_agent", "vif", port_rst_if);
    run_test();
  end

endmodule : tb
