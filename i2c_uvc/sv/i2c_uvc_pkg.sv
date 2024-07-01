`ifndef I2C_UVC_PKG_SV
`define I2C_UVC_PKG_SV

package i2c_uvc_pkg;

  `include "uvm_macros.svh"
  import uvm_pkg::*;

  `include "i2c_uvc_types.sv"
  `include "i2c_uvc_sequence_item.sv"
  `include "i2c_uvc_config.sv"
  `include "i2c_uvc_sequencer.sv"
  `include "i2c_uvc_driver.sv"
  `include "i2c_uvc_monitor.sv"
  `include "i2c_uvc_agent.sv"
  `include "i2c_uvc_sequence_base.sv"

  //`include "i2c_uvc_sequence_manual.sv"
  `include "i2c_uvc_sequence_rst.sv"
  //`include "i2c_uvc_sequence_pulse.sv"

endpackage : i2c_uvc_pkg

`endif  // I2C_UVC_PKG_SV
