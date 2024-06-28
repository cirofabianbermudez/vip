`ifndef I2C_UVC_SEQUENCE_MANUAL_SV
`define I2C_UVC_SEQUENCE_MANUAL_SV

class i2c_uvc_sequence_manual extends uvm_sequence #(i2c_uvc_sequence_item);

  `uvm_object_utils(i2c_uvc_sequence_manual)

  int num_of_trans = 5;

  int values[5] = '{10, 20, 30, 40, 50};


  extern function new(string name = "");
  extern virtual task body();
  extern function void display();

endclass : i2c_uvc_sequence_manual


function i2c_uvc_sequence_manual::new(string name = "");
  super.new(name);
endfunction : new


task i2c_uvc_sequence_manual::body();

    req = i2c_uvc_sequence_item::type_id::create("req");
    for (int i = 0; i < num_of_trans; i++) begin

      start_item(req);

      if (i == 0) begin
        req.trans_type = I2C_UVC_ITEM_ASYNC;
      end else begin
        req.trans_type = I2C_UVC_ITEM_SYNC;
      end

      req.gpio_pin = values[i];

      if ( i == num_of_trans - 1) begin
        req.trans_stage = I2C_UVC_ITEM_LAST;
      end

      finish_item(req);
    end

endtask : body



function void i2c_uvc_sequence_manual::display();
 `uvm_info(get_type_name(), "inside manual sequence", UVM_MEDIUM);
endfunction : display

`endif // I2C_UVC_SEQUENCE_MANUAL_SV
