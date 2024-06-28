`ifndef I2C_UVC_MONITOR_SV
`define I2C_UVC_MONITOR_SV

class i2c_uvc_monitor extends uvm_monitor;

  `uvm_component_utils(i2c_uvc_monitor)

  virtual i2c_uvc_if vif;
  i2c_uvc_config     cfg;
  uvm_analysis_port #(i2c_uvc_sequence_item) analysis_port;
  i2c_uvc_sequence_item trans;

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task do_mon();

endclass : i2c_uvc_monitor


function i2c_uvc_monitor::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new


function void i2c_uvc_monitor::build_phase(uvm_phase phase);
  if ( !uvm_config_db #(virtual i2c_uvc_if)::get(get_parent(), "", "vif", vif) ) begin
		  `uvm_fatal(get_name(), "Could not retrieve i2c_uvc_if from config db")
	end

  if ( !uvm_config_db #(i2c_uvc_config)::get(get_parent(), "", "cfg", cfg) ) begin
		  `uvm_fatal(get_name(), "Could not retrieve i2c_uvc_config from config db")
	end

  analysis_port = new("analysis_port", this);

endfunction : build_phase


task i2c_uvc_monitor::run_phase(uvm_phase phase);
  trans = i2c_uvc_sequence_item::type_id::create("trans");
  do_mon();
endtask : run_phase


task i2c_uvc_monitor::do_mon();
  forever begin
    if (cfg.is_active) begin
      @(vif.sda_io);
    end
    `uvm_info(get_type_name(), {"Got item ", trans.convert2string()}, UVM_MEDIUM)
    analysis_port.write(trans);
  end
endtask : do_mon



`endif // I2C_UVC_MONITOR_SV
