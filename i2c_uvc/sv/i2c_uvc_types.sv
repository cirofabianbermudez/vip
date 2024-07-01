`ifndef I2C_UVC_TYPES_SV
`define I2C_UVC_TYPES_SV

typedef enum {
  I2C_UVC_ITEM_FIRST,
  I2C_UVC_ITEM_MIDDLE,
  I2C_UVC_ITEM_LAST
} i2c_uvc_item_stage_e;

typedef enum {
  I2C_UVC_ITEM_SYNC,
  I2C_UVC_ITEM_ASYNC
} i2c_uvc_item_type_e;

typedef enum {
  I2C_UVC_ITEM_DELAY_OFF,
  I2C_UVC_ITEM_DELAY_ON
} i2c_uvc_item_delay_e;

typedef enum logic [2:0] {
  I2C_UVC_ITEM_START_CMD   = 3'b000,
  I2C_UVC_ITEM_WR_CMD      = 3'b001,
  I2C_UVC_ITEM_RS_CMD      = 3'b010,
  I2C_UVC_ITEM_STOP_CMD    = 3'b011,
  I2C_UVC_ITEM_RESTART_CMD = 3'b100
} i2c_uvc_item_cmd_e;

`endif  // I2C_UVC_TYPES_SV
