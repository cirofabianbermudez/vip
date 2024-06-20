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

`endif // I2C_UVC_TYPES_SV 
