`ifndef I2C_UVC_SEQUENCE_RST_SV
`define I2C_UVC_SEQUENCE_RST_SV

class i2c_uvc_sequence_rst extends uvm_sequence #(i2c_uvc_sequence_item);

  `uvm_object_utils(i2c_uvc_sequence_rst)

  int num_of_trans = 2;

  extern function new(string name = "");
  extern virtual task body();
  extern function void display();

endclass : i2c_uvc_sequence_rst


function i2c_uvc_sequence_rst::new(string name = "");
  super.new(name);
endfunction : new


task i2c_uvc_sequence_rst::body();
    req = i2c_uvc_sequence_item::type_id::create("req");
    for (int i = 0; i < num_of_trans; i++) begin

      start_item(req);

      if ( !req.randomize() with { delay_duration_ps inside { [5_000_000 : 10_000_000] }; } ) begin
        `uvm_error(get_type_name(), "Failed to randomize transaction")
      end

      req.data_in = 0;
      req.cmd = 0;
      req.write_en = 0;

      if (i == 0) begin
        req.rst = 1;
        req.trans_type   = I2C_UVC_ITEM_ASYNC;
        req.delay_enable = I2C_UVC_ITEM_DELAY_ON;
      end else begin
        req.rst = 0;
      end

      if ( i == num_of_trans - 1) begin
        req.trans_stage = I2C_UVC_ITEM_LAST;
      end

      finish_item(req);
    end
endtask : body


function void i2c_uvc_sequence_rst::display();
 `uvm_info(get_type_name(), "inside rst sequence", UVM_MEDIUM);
endfunction : display

`endif // I2C_UVC_SEQUENCE_RST_SV
