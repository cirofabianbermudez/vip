`ifndef GPIO_UVC_CONFIG_SV
`define GPIO_UVC_CONFIG_SV

class gpio_uvc_config extends uvm_object;

  `uvm_object_utils(gpio_uvc_config)

  uvm_active_passive_enum  is_active = UVM_ACTIVE;
  int                      pin_width = 8;
  local gpio_uvc_data_t    mask;

  extern function new(string name = "");
  extern function gpio_uvc_data_t get_mask();

endclass : gpio_uvc_config

function gpio_uvc_config::new(string name = "");
  super.new(name);
endfunction : new

function gpio_uvc_data_t gpio_uvc_config::get_mask();
  foreach (mask[i]) begin
    mask[i] = (i < pin_width);
  end
  return mask;
endfunction : get_mask

`endif // GPIO_UVC_CONFIG_SV
