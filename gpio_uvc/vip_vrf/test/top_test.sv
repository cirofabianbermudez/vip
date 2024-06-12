`ifndef TOP_TEST_SV
`define TOP_TEST_SV

class top_test extends uvm_test;

  `uvm_component_utils(top_test)

  top_env env;
  gpio_uvc_sequence_base seqA;
  gpio_uvc_sequence_base seqB;

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void end_of_elaboration_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

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


task top_test::run_phase(uvm_phase phase);

  seqA = gpio_uvc_sequence_base::type_id::create("seqA");
  seqB = gpio_uvc_sequence_base::type_id::create("seqA");

  phase.raise_objection(this);
  fork
    seqA.start(env.port_a_agent.sqr);
    seqB.start(env.port_b_agent.sqr);
  join
  phase.drop_objection(this);

endtask : run_phase

`endif // TOP_TEST_SV
