`ifndef GPIO_UVC_SEQUENCE_BASE_SV
`define GPIO_UVC_SEQUENCE_BASE_SV

class gpio_uvc_sequence_base extends uvm_sequence #(gpio_uvc_sequence_item);

  `uvm_object_utils(gpio_uvc_sequence_base)

  int num_of_trans = 3;

  extern function new(string name = "");
  extern virtual task body();

endclass : gpio_uvc_sequence_base


function gpio_uvc_sequence_base::new(string name = "");
  super.new(name);
endfunction : new


task gpio_uvc_sequence_base::body();
    req = gpio_uvc_sequence_item::type_id::create("req");
    for (int i = 0; i < num_of_trans; i++) begin
      start_item(req);
      if ( !req.randomize() ) begin
        `uvm_error(get_type_name(), "Failed to randomize transaction")
      end
      if ( i == num_of_trans - 1) begin
        req.trans_stage = GPIO_UVC_ITEM_LAST;
      end
      finish_item(req);
    end
endtask : body

`endif // GPIO_UVC_SEQUENCE_BASE_SV
