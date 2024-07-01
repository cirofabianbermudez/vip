`ifndef I2C_UVC_DRIVER_SV
`define I2C_UVC_DRIVER_SV

class i2c_uvc_driver extends uvm_driver #(i2c_uvc_sequence_item);

  `uvm_component_utils(i2c_uvc_driver)

  virtual i2c_uvc_if vif;
  i2c_uvc_config     cfg;

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

  extern task drive_sync();
  extern task drive_async();
  extern task do_drive();

endclass : i2c_uvc_driver


function i2c_uvc_driver::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new


function void i2c_uvc_driver::build_phase(uvm_phase phase);
  if (!uvm_config_db#(virtual i2c_uvc_if)::get(get_parent(), "", "vif", vif)) begin
    `uvm_fatal(get_name(), "Could not retrieve i2c_uvc_if from config db")
  end

  if (!uvm_config_db#(i2c_uvc_config)::get(get_parent(), "", "cfg", cfg)) begin
    `uvm_fatal(get_name(), "Could not retrieve i2c_uvc_config from config db")
  end

endfunction : build_phase


task i2c_uvc_driver::run_phase(uvm_phase phase);
  forever begin
    seq_item_port.get_next_item(req);
    do_drive();
    seq_item_port.item_done();
  end
endtask : run_phase


task i2c_uvc_driver::drive_sync();
  @(vif.cb_drv);
  vif.cb_drv.rst_i    <= req.rst;
  vif.cb_drv.dvsr_i   <= cfg.dvsr;
  vif.cb_drv.din_i    <= req.data_in;
  vif.cb_drv.wr_i2c_i <= req.write_en;
  vif.cb_drv.cmd_i    <= req.cmd;
endtask : drive_sync


task i2c_uvc_driver::drive_async();
  vif.rst_i    = req.rst;
  vif.dvsr_i   = cfg.dvsr;
  vif.din_i    = req.data_in;
  vif.wr_i2c_i = req.write_en;
  vif.cmd_i    = req.cmd;
  if (req.delay_enable == I2C_UVC_ITEM_DELAY_ON) begin
    $display($sformatf("\ndelay_enable: %5d, delay_duration_ps: %5d\n", req.delay_enable,
                       req.delay_duration_ps));
    #(req.delay_duration_ps * 1ps);
  end else begin
    @(vif.cb_drv);
  end
endtask : drive_async


task i2c_uvc_driver::do_drive();

  if (req.trans_type == I2C_UVC_ITEM_ASYNC) begin
    drive_async();
  end else begin
    drive_sync();
  end

  if (req.write_en) begin
    @(vif.cb_drv);
    vif.cb_drv.wr_i2c_i <= 1'b0;
    wait (vif.ready_o != 0);
    @(vif.cb_drv iff (vif.ready_o == 1));
    @(vif.cb_drv);
  end

  if (req.trans_stage == I2C_UVC_ITEM_LAST) begin
    repeat (100) @(vif.cb_drv);
  end

endtask : do_drive

`endif  // I2C_UVC_DRIVER_SV
