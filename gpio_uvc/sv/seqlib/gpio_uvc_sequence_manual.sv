`ifndef GPIO_UVC_SEQUENCE_MANUAL_SV
`define GPIO_UVC_SEQUENCE_MANUAL_SV

class gpio_uvc_sequence_manual extends uvm_sequence #(gpio_uvc_sequence_item);

  `uvm_object_utils(gpio_uvc_sequence_manual)

  int num_of_trans = 50;

  int values[5] = '{10, 20, 30, 40, 50};


  extern function new(string name = "");
  extern virtual task body();
  extern function void display();

endclass : gpio_uvc_sequence_manual


function gpio_uvc_sequence_manual::new(string name = "");
  super.new(name);
endfunction : new


task gpio_uvc_sequence_manual::body();

    req = gpio_uvc_sequence_item::type_id::create("req");
    for (int i = 0; i < num_of_trans; i++) begin

      start_item(req);

      if ( !req.randomize() with { gpio_pin inside {[0:255]}; } ) begin
        `uvm_error(get_type_name(), "Failed to randomize transaction")
      end

      if (i == 0) begin
        req.trans_type = GPIO_UVC_ITEM_ASYNC;
      end else begin
        req.trans_type = GPIO_UVC_ITEM_SYNC;
      end

      if (i < 5) begin
        req.gpio_pin = values[i];
      end

      if ( i == num_of_trans - 1) begin
        req.trans_stage = GPIO_UVC_ITEM_LAST;
      end

      finish_item(req);
    end

endtask : body



function void gpio_uvc_sequence_manual::display();
 `uvm_info(get_type_name(), "inside manual sequence", UVM_MEDIUM);
endfunction : display

`endif // GPIO_UVC_SEQUENCE_MANUAL_SV
