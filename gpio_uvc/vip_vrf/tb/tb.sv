module tb;
  import uvm_pkg::*;
  import top_test_pkg::*;

  // Clock generator
  logic clk;
  always #5 clk = ~clk;

  initial begin
    clk = 0;
  end

  logic [7:0] portA;
  logic [7:0] portB;
  
  gpio_uvc_if port_a_if(clk);
  gpio_uvc_if port_b_if(clk);

  assign portA = port_a_if.gpio_pin;
  assign portB = port_b_if.gpio_pin;
  
  initial begin
    $timeformat(-9, 0, "ns", 10);
    $fsdbDumpvars;
    uvm_config_db #(virtual gpio_uvc_if)::set(null, "uvm_test_top.env.port_a_agent", "vif", port_a_if);
    uvm_config_db #(virtual gpio_uvc_if)::set(null, "uvm_test_top.env.port_b_agent", "vif", port_b_if);
    run_test();
  end

endmodule : tb
