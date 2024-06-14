`ifndef GPIO_UVC_IF_SV
`define GPIO_UVC_IF_SV

interface gpio_uvc_if (
  input logic clk
);

  // Changed from logic to wire to remove warning
  wire [7:0] gpio_pin;

  clocking cb_drv @(posedge clk);
    default output #1ns;
    output gpio_pin;
  endclocking : cb_drv

  clocking cb_mon @(posedge clk);
    default input #1ns;
    input gpio_pin;
  endclocking : cb_mon

endinterface : gpio_uvc_if

`endif // GPIO_UVC_IF_SV
