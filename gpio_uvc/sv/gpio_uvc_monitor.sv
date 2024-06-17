`ifndef GPIO_UVC_MONITOR_SV
`define GPIO_UVC_MONITOR_SV

class gpio_uvc_monitor extends uvm_monitor;

  `uvm_component_utils(gpio_uvc_monitor)

  virtual gpio_uvc_if vif;
  gpio_uvc_config    cfg;
  uvm_analysis_port #(gpio_uvc_sequence_item) analysis_port;
  gpio_uvc_sequence_item trans;

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task do_mon();

endclass : gpio_uvc_monitor


function gpio_uvc_monitor::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new


function void gpio_uvc_monitor::build_phase(uvm_phase phase);
  if ( !uvm_config_db #(virtual gpio_uvc_if)::get(get_parent(), "", "vif", vif) ) begin
		  `uvm_fatal(get_name(), "Could not retrieve gpio_uvc_if from config db")
	end

  if ( !uvm_config_db #(gpio_uvc_config)::get(get_parent(), "", "cfg", cfg) ) begin
		  `uvm_fatal(get_name(), "Could not retrieve gpio_uvc_config from config db")
	end

  analysis_port = new("analysis_port", this);

endfunction : build_phase


task gpio_uvc_monitor::run_phase(uvm_phase phase);
  trans = gpio_uvc_sequence_item::type_id::create("trans");
  do_mon();
endtask : run_phase


task gpio_uvc_monitor::do_mon();
  forever begin
    if (cfg.is_active) begin
      @(vif.gpio_pin)
      trans.gpio_pin = vif.gpio_pin;
    end else begin
      @(vif.gpio_pin_passive)
      trans.gpio_pin = vif.gpio_pin_passive & cfg.get_mask();
      //$display("Value: %b\nMask:  %b\nAND:   %b", vif.gpio_pin_passive, cfg.get_mask(), trans.gpio_pin);
    end
    `uvm_info(get_type_name(), {"Got item ", trans.convert2string()}, UVM_MEDIUM)
    analysis_port.write(trans);
  end
endtask : do_mon



`endif // GPIO_UVC_MONITOR_SV
