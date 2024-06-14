`ifndef TOP_TEST_SV
`define TOP_TEST_SV

class top_test extends uvm_test;

  `uvm_component_utils(top_test)

  top_env env;

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

  //set_inst_override_by_type("env.port_a_agent.*",gpio_uvc_sequence_item::get_type(), gpio_uvc_sequence_item_2::get_type() );
  //set_inst_override_by_type("seqA.*",gpio_uvc_sequence_item::get_type(), gpio_uvc_sequence_item_2::get_type() );
  //set_type_override_by_type(gpio_uvc_sequence_item::get_type(), gpio_uvc_sequence_item_2::get_type() );
  //set_type_override_by_type(gpio_uvc_sequence_item::get_type(), gpio_uvc_sequence_item_2::get_type() );
  //set_inst_override_by_type("*",gpio_uvc_sequence_base::get_type(),gpio_uvc_sequence_small::get_type());
  //gpio_uvc_sequence_base::type_id::set_type_override(gpio_uvc_sequence_small::get_type());
  //gpio_uvc_sequence_item::type_id::set_inst_override(gpio_uvc_sequence_item_small::get_type(), "env.");
  //gpio_uvc_sequence_item::type_id::set_inst_override(gpio_uvc_sequence_item_small::get_type(), "env.port_a_agent.*");
  //gpio_uvc_sequence_item::type_id::set_inst_override(gpio_uvc_sequence_item_small::get_type(), "vseq.*");
endfunction : build_phase


function void top_test::end_of_elaboration_phase(uvm_phase phase);
  uvm_root::get().print_topology();
  uvm_factory::get().print();
endfunction : end_of_elaboration_phase


task top_test::run_phase(uvm_phase phase);
  vseq_base vseq;
  vseq = vseq_base::type_id::create("vseq");
  phase.raise_objection(this);
  vseq.a_sqr = env.port_a_agent.sqr;
  vseq.b_sqr = env.port_b_agent.sqr;
  vseq.rst_sqr = env.port_rst_agent.sqr;
  vseq.start(null);
  phase.drop_objection(this);

endtask : run_phase

`endif // TOP_TEST_SV
