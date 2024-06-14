`ifndef GPIO_UVC_DRIVER_SV
`define GPIO_UVC_DRIVER_SV

class gpio_uvc_driver #(int WIDTH = 8) extends uvm_driver #(gpio_uvc_sequence_item);

  typedef gpio_uvc_driver #(WIDTH) gpio_uvc_driver_t;
  `uvm_component_param_utils(gpio_uvc_driver_t)

  typedef virtual gpio_uvc_if #(WIDTH) gpio_uvc_if_t;
  gpio_uvc_if_t vif;

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

  extern task drive_sync();
  extern task drive_async();
  extern task do_drive();

endclass : gpio_uvc_driver


function gpio_uvc_driver::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new


function void gpio_uvc_driver::build_phase(uvm_phase phase);
  if ( !uvm_config_db #(gpio_uvc_if_t)::get(get_parent(), "", "vif", vif) ) begin
		  `uvm_fatal(get_name(), "Could not retrieve gpio_uvc_if from config db")
	end
endfunction : build_phase


task gpio_uvc_driver::run_phase(uvm_phase phase);
  forever begin
    seq_item_port.get_next_item(req);
    do_drive();
    seq_item_port.item_done();
  end
endtask : run_phase


task gpio_uvc_driver::drive_sync();
  @(vif.cb_drv);
  vif.cb_drv.gpio_pin <= req.gpio_pin[WIDTH-1:0];
endtask : drive_sync


task gpio_uvc_driver::drive_async();
  vif.gpio_pin = req.gpio_pin[WIDTH-1:0];
endtask : drive_async


task gpio_uvc_driver::do_drive();

  if (req.trans_type == GPIO_UVC_ITEM_ASYNC) begin
    drive_async();
  end else begin
    drive_sync();
  end

  if (req.trans_stage == GPIO_UVC_ITEM_LAST) begin
    repeat(2) @(vif.cb_drv);
  end

endtask : do_drive

`endif // GPIO_UVC_DRIVER_SV
