`ifndef GPIO_UVC_SEQUENCE_RST_PULSE_SV
`define GPIO_UVC_SEQUENCE_RST_PULSE_SV

class gpio_uvc_sequence_rst_pulse extends uvm_sequence #(gpio_uvc_sequence_item);

  `uvm_object_utils(gpio_uvc_sequence_rst_pulse)


  extern function new(string name = "");
  extern virtual task body();

  virtual function display();
    `uvm_info(get_type_name(), "inside rst_pulse", UVM_MEDIUM);
  endfunction

endclass : gpio_uvc_sequence_rst_pulse


function gpio_uvc_sequence_rst_pulse::new(string name = "");
  super.new(name);
endfunction : new


task gpio_uvc_sequence_rst_pulse::body();

    req = gpio_uvc_sequence_item::type_id::create("req");
    start_item(req);
    req.gpio_pin = 8'd1;
    req.trans_type = GPIO_UVC_ITEM_ASYNC;
    req.trans_stage = GPIO_UVC_ITEM_FIRST;
    finish_item(req);

    req = gpio_uvc_sequence_item::type_id::create("req");
    start_item(req);
    req.gpio_pin = 8'd0;
    req.trans_type = GPIO_UVC_ITEM_SYNC;
    req.trans_stage = GPIO_UVC_ITEM_MIDDLE;
    finish_item(req);

    req = gpio_uvc_sequence_item::type_id::create("req");
    start_item(req);
    req.gpio_pin = 8'd0;
    req.trans_type = GPIO_UVC_ITEM_SYNC;
    req.trans_stage = GPIO_UVC_ITEM_LAST;
    finish_item(req);

endtask : body


`endif // GPIO_UVC_SEQUENCE_RST_PULSE_SV
