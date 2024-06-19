`ifndef GPIO_UVC_SEQUENCE_PULSE_SV
`define GPIO_UVC_SEQUENCE_PULSE_SV

class gpio_uvc_sequence_pulse extends uvm_sequence #(gpio_uvc_sequence_item);

  `uvm_object_utils(gpio_uvc_sequence_pulse)

  int num_of_trans = 50;

  extern function new(string name = "");
  extern virtual task body();
  extern function void display();

endclass : gpio_uvc_sequence_pulse


function gpio_uvc_sequence_pulse::new(string name = "");
  super.new(name);
endfunction : new


task gpio_uvc_sequence_pulse::body();
    req = gpio_uvc_sequence_item::type_id::create("req");
    for (int i = 0; i < num_of_trans; i++) begin

      start_item(req);

      if ( !req.randomize() with { 
        gpio_pin inside {1,0}; 
        delay_duration_ps inside {[ 5_000 : 10_000]}; // 8ns - 30ns
        }) begin
        `uvm_error(get_type_name(), "Failed to randomize transaction")
      end

      req.trans_type = GPIO_UVC_ITEM_ASYNC;
      if (i == 0) begin
        req.gpio_pin = 1;
        req.delay_enable = GPIO_UVC_ITEM_DELAY_ON;
      //end else begin
      //  req.delay_enable = GPIO_UVC_ITEM_DELAY_OFF;
      //  req.gpio_pin = 0;
      end

      if ( i == num_of_trans - 1) begin
        req.trans_stage = GPIO_UVC_ITEM_LAST;
      end

      finish_item(req);
    end
endtask : body


function void gpio_uvc_sequence_pulse::display();
 `uvm_info(get_type_name(), "inside rst sequence", UVM_MEDIUM);
endfunction : display

`endif // GPIO_UVC_SEQUENCE_PULSE_SV
