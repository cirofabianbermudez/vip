`ifndef GPIO_UVC_SEQUENCE_ITEM_SMALL_SV
`define GPIO_UVC_SEQUENCE_ITEM_SMALL_SV

class gpio_uvc_sequence_item_small extends gpio_uvc_sequence_item;

  `uvm_object_utils(gpio_uvc_sequence_item_small)

  //rand logic [7:0] gpio_pin;

  extern function new(string name = "");

  constraint some_constraint {
    gpio_pin == 1;
  }

endclass : gpio_uvc_sequence_item_small


function gpio_uvc_sequence_item_small::new(string name = "");
  super.new(name);
endfunction : new


`endif // GPIO_UVC_SEQUENCE_ITEM_SMALL_SV
