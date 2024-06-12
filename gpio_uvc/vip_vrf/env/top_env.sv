`ifndef TOP_ENV_SV
`define TOP_ENV_SV

class top_env extends uvm_env;

  `uvm_component_utils(top_env)

  gpio_uvc_agent   port_a_agent;
  gpio_uvc_config  port_a_agent_cfg;

  gpio_uvc_agent   port_b_agent;
  gpio_uvc_config  port_b_agent_cfg;

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern function void build_agents();

endclass : top_env


function top_env::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new


function void top_env::build_phase(uvm_phase phase);
  build_agents();
endfunction : build_phase


function void top_env::connect_phase(uvm_phase phase);
endfunction : connect_phase


function void top_env::build_agents();

  port_a_agent_cfg = gpio_uvc_config::type_id::create("port_a_agent_cfg", this);
  port_a_agent_cfg.is_active = UVM_ACTIVE;
  uvm_config_db #(gpio_uvc_config)::set(this, "port_a_agent", "cfg", port_a_agent_cfg);
  port_a_agent = gpio_uvc_agent::type_id::create("port_a_agent", this);


  port_b_agent_cfg = gpio_uvc_config::type_id::create("port_b_agent_cfg", this);
  port_b_agent_cfg.is_active = UVM_ACTIVE;
  uvm_config_db #(gpio_uvc_config)::set(this, "port_b_agent", "cfg", port_b_agent_cfg);
  port_b_agent = gpio_uvc_agent::type_id::create("port_b_agent", this);

endfunction : build_agents

`endif // TOP_ENV_SV
