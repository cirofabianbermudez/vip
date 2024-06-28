`ifndef VSEQ_BASE_SV
`define VSEQ_BASE_SV

class vseq_base extends uvm_sequence;

  `uvm_object_utils(vseq_base)

  // Sequences
  i2c_uvc_sequence_base seqA;
  i2c_uvc_sequence_rst  seqB;

  // Sequencers
  i2c_uvc_sequencer sqrA;

  extern function new(string name = "");
  extern task body();

endclass : vseq_base


function vseq_base::new(string name = "");
  super.new(name);
endfunction : new


task vseq_base::body();
  seqA = i2c_uvc_sequence_base::type_id::create("seqA");
  seqA.display();
  seqB = i2c_uvc_sequence_rst::type_id::create("seqB");
  seqB.display();
  //fork
    seqB.start(sqrA, this);
    seqA.start(sqrA, this);
  //join
endtask : body

`endif // VSEQ_BASE_SV
