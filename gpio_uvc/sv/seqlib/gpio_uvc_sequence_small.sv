`ifndef GPIO_UVC_SEQUENCE_SMALL_SV
`define GPIO_UVC_SEQUENCE_SMALL_SV

class gpio_uvc_sequence_small extends uvm_sequence #(gpio_uvc_sequence_item);

  `uvm_object_utils(gpio_uvc_sequence_small)

  int num_of_trans = 3;

  extern function new(string name = "");
  extern virtual task body();

  virtual function display();
    `uvm_info(get_type_name(), "inside small", UVM_MEDIUM);
  endfunction

endclass : gpio_uvc_sequence_small


function gpio_uvc_sequence_small::new(string name = "");
  super.new(name);
endfunction : new


task gpio_uvc_sequence_small::body();
    req = gpio_uvc_sequence_item::type_id::create("req");
    for (int i = 0; i < num_of_trans; i++) begin
      start_item(req);
      if ( !req.randomize() with { gpio_pin == 1;} ) begin
        `uvm_error(get_type_name(), "Failed to randomize transaction")
      end
      if ( i == num_of_trans - 1) begin
        req.trans_stage = GPIO_UVC_ITEM_LAST;
      end
      finish_item(req);
    end
endtask : body


`endif // GPIO_UVC_SEQUENCE_SMALL_SV
