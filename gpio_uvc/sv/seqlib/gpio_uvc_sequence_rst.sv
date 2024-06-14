`ifndef GPIO_UVC_SEQUENCE_RST_SV
`define GPIO_UVC_SEQUENCE_RST_SV

class gpio_uvc_sequence_rst extends uvm_sequence #(gpio_uvc_sequence_item);

  `uvm_object_utils(gpio_uvc_sequence_rst)

  int num_of_trans = 3;

  extern function new(string name = "");
  extern virtual task body();

  virtual function display();
    `uvm_info(get_type_name(), "inside rst", UVM_MEDIUM);
  endfunction

endclass : gpio_uvc_sequence_rst


function gpio_uvc_sequence_rst::new(string name = "");
  super.new(name);
endfunction : new


task gpio_uvc_sequence_rst::body();
    req = gpio_uvc_sequence_item::type_id::create("req");
    for (int i = 0; i < num_of_trans; i++) begin
      start_item(req);
      if ( !req.randomize() with { gpio_pin inside {1,0};} ) begin
        `uvm_error(get_type_name(), "Failed to randomize transaction")
      end
      if ( i == num_of_trans - 1) begin
        req.trans_stage = GPIO_UVC_ITEM_LAST;
      end
      finish_item(req);
    end
endtask : body


`endif // GPIO_UVC_SEQUENCE_RST_SV
