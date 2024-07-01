`ifndef TOP_TEST_SV
`define TOP_TEST_SV

class top_test extends uvm_test;

  `uvm_component_utils(top_test)

  top_env   env;
  vseq_base vseq;

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void end_of_elaboration_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern function void init_vseq();

endclass : top_test


function top_test::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new


function void top_test::build_phase(uvm_phase phase);
  env = top_env::type_id::create("env", this);
  `uvm_info(get_type_name(), "env created", UVM_MEDIUM)
endfunction : build_phase


function void top_test::end_of_elaboration_phase(uvm_phase phase);
  uvm_root::get().print_topology();
  uvm_factory::get().print();
endfunction : end_of_elaboration_phase


function void top_test::init_vseq();
  vseq.sqrA = env.i2c_agent.sqr;
endfunction : init_vseq


task top_test::run_phase(uvm_phase phase);

  vseq = vseq_base::type_id::create("vseq");

  phase.raise_objection(this);
  init_vseq();
  vseq.start(null);
  phase.drop_objection(this);

endtask : run_phase

`endif  // TOP_TEST_SV
