`ifndef TOP_ENV_SV
`define TOP_ENV_SV

class top_env extends uvm_env;

  `uvm_component_utils(top_env)

  i2c_uvc_agent   i2c_agent;
  i2c_uvc_config  i2c_agent_cfg;

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

  i2c_agent_cfg = i2c_uvc_config::type_id::create("i2c_agent_cfg", this);
  i2c_agent_cfg.is_active = UVM_ACTIVE;
  i2c_agent_cfg.clk_freq = 100_000_000;  // 100 MHz
  i2c_agent_cfg.i2c_freq = 100_000;       // 100 kbps
  uvm_config_db #(i2c_uvc_config)::set(this, "i2c_agent", "cfg", i2c_agent_cfg);
  i2c_agent = i2c_uvc_agent::type_id::create("i2c_agent", this);

endfunction : build_agents

`endif // TOP_ENV_SV
