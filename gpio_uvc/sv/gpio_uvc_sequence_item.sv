`ifndef GPIO_UVC_SEQUENCE_ITEM_SV
`define GPIO_UVC_SEQUENCE_ITEM_SV

class gpio_uvc_sequence_item extends uvm_sequence_item;

  `uvm_object_utils(gpio_uvc_sequence_item)

  gpio_uvc_item_stage_e  trans_stage = GPIO_UVC_ITEM_MIDDLE;
  gpio_uvc_item_type_e   trans_type  = GPIO_UVC_ITEM_SYNC;

  rand logic [7:0] gpio_pin;

  extern function new(string name = "");
  extern function void do_copy(uvm_object rhs);
  extern function bit  do_compare(uvm_object rhs, uvm_comparer comparer);
  extern function string convert2string();

endclass : gpio_uvc_sequence_item


function gpio_uvc_sequence_item::new(string name = "");
  super.new(name);
endfunction


function void gpio_uvc_sequence_item::do_copy(uvm_object rhs);
  gpio_uvc_sequence_item rhs_;
  if (!$cast(rhs_, rhs)) begin
    `uvm_fatal(get_type_name(), "Cast of rhs object failed")
  end
  super.do_copy(rhs);
  gpio_pin = rhs_.gpio_pin;
  trans_stage = rhs_.trans_stage;
  trans_type = rhs_.trans_type;
endfunction : do_copy


function bit gpio_uvc_sequence_item::do_compare(uvm_object rhs, uvm_comparer comparer);
  bit result;
  gpio_uvc_sequence_item rhs_;
  if (!$cast(rhs_, rhs)) begin
    `uvm_fatal(get_type_name(), "Cast of rhs object failed")
  end
  result = super.do_compare(rhs, comparer);
  result &= (gpio_pin == rhs_.gpio_pin);
  return result;
endfunction : do_compare


function string gpio_uvc_sequence_item::convert2string();
  string s;
  s = super.convert2string();
  $sformat(s, "gpio_pin = 'd%0d", gpio_pin);
  return s;
endfunction : convert2string


`endif // GPIO_UVC_SEQUENCE_ITEM_SV
