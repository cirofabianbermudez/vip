`ifndef I2C_UVC_IF_SV
`define I2C_UVC_IF_SV

interface i2c_uvc_if (
  input logic        clk_i,
  input logic        rst_i,
  input logic [15:0] dvsr_i
);

  logic [ 7:0] din_i;
  logic [ 2:0] cmd_i;
  logic        wr_i2c_i;
  wire         scl_io;
  wire         sda_io;
  logic        ready_o;
  logic        done_tick_o;
  logic        ack_o;
  logic [ 7:0] dout_o;

  assign (pull1, highz0) scl_io = 1'b1;
  assign (pull1, highz0) sda_io = 1'b1;

  clocking cb_drv @(posedge clk);
    default output #1ns;
    output din_i;
    output cmd_i;
    output wr_i2c_i;
    inout  scl_io;
    inout  sda_io;
  endclocking : cb_drv

  clocking cb_mon @(posedge clk);
    default input #1ns;
    input  ready_o;
    input  done_tick_o;
    input  ack_o;
    input  dout_o;
  endclocking : cb_mon

  modport drv (clocking cb_drv);
  modport mon (clocking cb_mon);

endinterface : i2c_uvc_if

`endif // I2C_UVC_IF_SV
