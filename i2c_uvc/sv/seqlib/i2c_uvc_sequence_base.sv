`ifndef I2C_UVC_SEQUENCE_BASE_SV
`define I2C_UVC_SEQUENCE_BASE_SV

class i2c_uvc_sequence_base extends uvm_sequence #(i2c_uvc_sequence_item);

  `uvm_object_utils(i2c_uvc_sequence_base)

  int num_of_trans = 1;

  extern function new(string name = "");
  extern virtual task body();
  extern function void display();

endclass : i2c_uvc_sequence_base


function i2c_uvc_sequence_base::new(string name = "");
  super.new(name);
endfunction : new


task i2c_uvc_sequence_base::body();
  req = i2c_uvc_sequence_item::type_id::create("req");

  // Start CMD
  start_item(req);
  if (!req.randomize() with {
        write_data inside {[0 : 255]};
        address inside {[0 : 127]};
      }) begin
    `uvm_error(get_type_name(), "Failed to randomize transaction")
  end

  req.cmd            = I2C_UVC_ITEM_START_CMD;
  req.rst            = 0;
  req.read_write_bit = 0;
  req.data_in        = {req.address, req.read_write_bit};
  req.write_en       = 1;
  finish_item(req);

  // Address CMD
  start_item(req);
  req.cmd = I2C_UVC_ITEM_WR_CMD;
  finish_item(req);

  repeat (req.num_bytes) begin
    // Write Byte
    start_item(req);
    req.cmd     = I2C_UVC_ITEM_WR_CMD;
    req.data_in = req.write_data;
    finish_item(req);
  end

  // Stop CMD
  start_item(req);
  req.cmd         = I2C_UVC_ITEM_STOP_CMD;
  req.trans_stage = I2C_UVC_ITEM_LAST;
  finish_item(req);

endtask : body


function void i2c_uvc_sequence_base::display();
  `uvm_info(get_type_name(), "inside base sequence", UVM_MEDIUM);
endfunction : display

`endif  // I2C_UVC_SEQUENCE_BASE_SV
