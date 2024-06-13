`ifndef GPIO_UVC_AGENT_SV
`define GPIO_UVC_AGENT_SV

class gpio_uvc_agent #(int WIDTH = 8) extends uvm_agent;

  typedef gpio_uvc_agent #(WIDTH) gpio_uvc_agent_t;
  `uvm_component_param_utils(gpio_uvc_agent_t)

  uvm_analysis_port #(gpio_uvc_sequence_item) analysis_port;

  typedef gpio_uvc_driver  #(WIDTH) gpio_uvc_driver_t;
  typedef gpio_uvc_monitor #(WIDTH) gpio_uvc_monitor_t;

  gpio_uvc_sequencer  sqr;
  gpio_uvc_driver_t   drv;
  gpio_uvc_monitor_t  mon;
  gpio_uvc_config     cfg;

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);

endclass : gpio_uvc_agent


function  gpio_uvc_agent::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new


function void gpio_uvc_agent::build_phase(uvm_phase phase);

  if ( !uvm_config_db #(gpio_uvc_config)::get(this, "", "cfg", cfg) ) begin
		  `uvm_fatal(get_name(), "Could not retrieve gpio_uvc_config from config db")
	end

  if (cfg.is_active == UVM_ACTIVE) begin
    sqr = gpio_uvc_sequencer::type_id::create("sqr", this);
    drv = gpio_uvc_driver_t::type_id::create("drv", this);
    `uvm_info(get_type_name(), "sqr created", UVM_MEDIUM)
    `uvm_info(get_type_name(), "drv created", UVM_MEDIUM)
  end

  mon = gpio_uvc_monitor_t::type_id::create("mon", this);
  `uvm_info(get_type_name(), "mon created", UVM_MEDIUM)

  analysis_port = new("analysis_port", this);

endfunction : build_phase


function void gpio_uvc_agent::connect_phase(uvm_phase phase);

  if (cfg.is_active == UVM_ACTIVE) begin
    drv.seq_item_port.connect(sqr.seq_item_export);
    `uvm_info(get_type_name(), "drv and sqr connected", UVM_MEDIUM)
  end

  mon.analysis_port.connect(this.analysis_port);

endfunction : connect_phase


`endif // GPIO_UVC_AGENT_SV
