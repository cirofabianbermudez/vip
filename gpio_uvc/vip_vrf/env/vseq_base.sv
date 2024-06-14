`ifndef VSEQ_BASE_SV
`define VSEQ_BASE_SV

class vseq_base extends uvm_sequence;

  `uvm_object_utils(vseq_base)

  // Sequences
  gpio_uvc_sequence_base seqA;
  gpio_uvc_sequence_base seqB;
  gpio_uvc_sequence_rst_pulse  seqRST;

  // Sequencers
  gpio_uvc_sequencer a_sqr;
  gpio_uvc_sequencer b_sqr;
  gpio_uvc_sequencer rst_sqr;

  extern function new(string name = "");
  extern task body();

endclass : vseq_base


function vseq_base::new(string name = "");
  super.new(name);
endfunction : new


task vseq_base::body();
  seqA = gpio_uvc_sequence_base::type_id::create("seqA");
  seqB = gpio_uvc_sequence_base::type_id::create("seqB");
  seqRST = gpio_uvc_sequence_rst_pulse::type_id::create("seqRST");
  seqA.display();
  seqB.display();
  seqRST.display();
  fork
    seqA.start(a_sqr, this);
    seqB.start(b_sqr, this);
    seqRST.start(rst_sqr, this);
  join
endtask : body


`endif // VSEQ_BASE_SV

