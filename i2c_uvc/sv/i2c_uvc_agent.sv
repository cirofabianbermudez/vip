`ifndef I2C_UVC_AGENT_SV
`define I2C_UVC_AGENT_SV

class i2c_uvc_agent extends uvm_agent;

  `uvm_component_utils(i2c_uvc_agent)

  uvm_analysis_port #(i2c_uvc_sequence_item) analysis_port;

  i2c_uvc_sequencer sqr;
  i2c_uvc_driver    drv;
  i2c_uvc_monitor   mon;
  i2c_uvc_config    cfg;

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);

endclass : i2c_uvc_agent


function i2c_uvc_agent::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new


function void i2c_uvc_agent::build_phase(uvm_phase phase);

  if (!uvm_config_db#(i2c_uvc_config)::get(this, "", "cfg", cfg)) begin
    `uvm_fatal(get_name(), "Could not retrieve i2c_uvc_config from config db")
  end

  if (cfg.is_active == UVM_ACTIVE) begin
    sqr = i2c_uvc_sequencer::type_id::create("sqr", this);
    drv = i2c_uvc_driver::type_id::create("drv", this);
    `uvm_info(get_type_name(), "sqr created", UVM_MEDIUM)
    `uvm_info(get_type_name(), "drv created", UVM_MEDIUM)
  end

  mon = i2c_uvc_monitor::type_id::create("mon", this);
  `uvm_info(get_type_name(), "mon created", UVM_MEDIUM)

  analysis_port = new("analysis_port", this);

endfunction : build_phase


function void i2c_uvc_agent::connect_phase(uvm_phase phase);

  if (cfg.is_active == UVM_ACTIVE) begin
    drv.seq_item_port.connect(sqr.seq_item_export);
    `uvm_info(get_type_name(), "drv and sqr connected", UVM_MEDIUM)
  end

  mon.analysis_port.connect(this.analysis_port);

endfunction : connect_phase


`endif  // I2C_UVC_AGENT_SV
