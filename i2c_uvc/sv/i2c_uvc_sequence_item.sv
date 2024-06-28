`ifndef I2C_UVC_SEQUENCE_ITEM_SV
`define I2C_UVC_SEQUENCE_ITEM_SV

class i2c_uvc_sequence_item extends uvm_sequence_item;

  `uvm_object_utils(i2c_uvc_sequence_item)

  i2c_uvc_item_stage_e  trans_stage        = I2C_UVC_ITEM_MIDDLE;
  i2c_uvc_item_type_e   trans_type         = I2C_UVC_ITEM_SYNC;
  i2c_uvc_item_delay_e  delay_enable       = I2C_UVC_ITEM_DELAY_OFF;
  rand int unsigned     delay_duration_ps;

  // Randoom Values for transaction
  rand logic [ 6:0]  address;
  rand logic [ 7:0]  write_data;
  rand int unsigned  num_bytes;
  rand logic         read_write_bit;

  // DUT input pins
  rand logic [ 7:0]  data_in;
  rand logic [ 2:0]  cmd;
  rand logic         rst;
  rand logic         write_en;

  
  // DUT output pins
  logic [7:0] read_data;
  logic       ack_bit;

  extern function new(string name = "");
  extern function void do_copy(uvm_object rhs);
  extern function bit  do_compare(uvm_object rhs, uvm_comparer comparer);
  extern function string convert2string();

  // IMPORTANT -timescale=1ps/100fs to avoid Verdi errors
  constraint c_delay {
    soft delay_duration_ps inside { [1_000 : 10_000] }; // 1ns - 10ns
  }

  constraint c_num_bytes {
    soft num_bytes inside { [1 : 2] };
  }

endclass : i2c_uvc_sequence_item


function i2c_uvc_sequence_item::new(string name = "");
  super.new(name);
endfunction


function void i2c_uvc_sequence_item::do_copy(uvm_object rhs);
  i2c_uvc_sequence_item rhs_;
  if (!$cast(rhs_, rhs)) begin
    `uvm_fatal(get_type_name(), "Cast of rhs object failed")
  end
  super.do_copy(rhs);

  address        = rhs_.address;
  write_data     = rhs_.write_data;
  num_bytes      = rhs_.num_bytes;

  data_in        = rhs_.data_in;
  cmd            = rhs_.cmd;
  rst            = rhs_.rst;
  read_write_bit = rhs_.read_write_bit;
  write_en       = rhs_.write_en;


  read_data      = rhs_.read_data;
  ack_bit        = rhs_.ack_bit;

  trans_stage       = rhs_.trans_stage;
  trans_type        = rhs_.trans_type;
  delay_enable      = rhs_.delay_enable;
  delay_duration_ps = rhs_.delay_duration_ps;

endfunction : do_copy


function bit i2c_uvc_sequence_item::do_compare(uvm_object rhs, uvm_comparer comparer);
  bit result;
  i2c_uvc_sequence_item rhs_;
  if (!$cast(rhs_, rhs)) begin
    `uvm_fatal(get_type_name(), "Cast of rhs object failed")
  end
  result = super.do_compare(rhs, comparer);
  result &= (address == rhs_.address);
  result &= (write_data == rhs_.write_data);
  return result;
endfunction : do_compare


function string i2c_uvc_sequence_item::convert2string();
  string s;
  s = super.convert2string();
  $sformat(s, "address = 'd%3d, write_data 'd%0d", address, write_data);
  return s;
endfunction : convert2string


`endif // I2C_UVC_SEQUENCE_ITEM_SV
