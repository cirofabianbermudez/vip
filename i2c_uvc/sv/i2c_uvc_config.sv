`ifndef I2C_UVC_CONFIG_SV
`define I2C_UVC_CONFIG_SV

class i2c_uvc_config extends uvm_object;

  `uvm_object_utils(i2c_uvc_config)

  uvm_active_passive_enum  is_active = UVM_ACTIVE;

  extern function new(string name = "");

endclass : i2c_uvc_config

function i2c_uvc_config::new(string name = "");
  super.new(name);
endfunction : new

`endif // I2C_UVC_CONFIG_SV
