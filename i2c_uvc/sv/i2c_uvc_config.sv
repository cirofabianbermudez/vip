`ifndef I2C_UVC_CONFIG_SV
`define I2C_UVC_CONFIG_SV

class i2c_uvc_config extends uvm_object;

  `uvm_object_utils(i2c_uvc_config)

  uvm_active_passive_enum  is_active = UVM_ACTIVE;
  int unsigned              clk_freq = 100_000_000;
  int unsigned              i2c_freq = 100_000;
  logic [15:0]              dvsr;

  extern function new(string name = "");
  extern function logic [15:0] calculate_dvsr(int unsigned clk_freq, int unsigned i2c_freq);

endclass : i2c_uvc_config

function i2c_uvc_config::new(string name = "");
  super.new(name);
  dvsr = calculate_dvsr(clk_freq, i2c_freq);
endfunction : new

function logic [15:0] i2c_uvc_config::calculate_dvsr(int unsigned clk_freq, int unsigned i2c_freq);
  return clk_freq / (i2c_freq * 4);
endfunction : calculate_dvsr

`endif // I2C_UVC_CONFIG_SV
