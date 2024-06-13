`ifndef GPIO_UVC_SEQUENCE_ITEM_2_SV
`define GPIO_UVC_SEQUENCE_ITEM_2_SV

class gpio_uvc_sequence_item_2 extends uvm_sequence_item;

  `uvm_object_utils(gpio_uvc_sequence_item)

  rand logic [7:0] gpio_pin;

  constraint two_values {
    gpio_pin inside {11, 22};
  }

endclass : gpio_uvc_sequence_item_2


`endif // GPIO_UVC_SEQUENCE_ITEM_2_SV
