`ifndef GPIO_UVC_TYPES_SV
`define GPIO_UVC_TYPES_SV

parameter int GPIO_UVC_MAX_WIDTH = 32;
typedef logic [GPIO_UVC_MAX_WIDTH-1:0] gpio_uvc_data_t;

typedef enum {
  GPIO_UVC_ITEM_FIRST, 
  GPIO_UVC_ITEM_MIDDLE, 
  GPIO_UVC_ITEM_LAST
} gpio_uvc_item_stage_e;

typedef enum {
  GPIO_UVC_ITEM_SYNC,
  GPIO_UVC_ITEM_ASYNC
} gpio_uvc_item_type_e;

typedef enum {
  GPIO_UVC_ITEM_DELAY_OFF,
  GPIO_UVC_ITEM_DELAY_ON
} gpio_uvc_item_delay_e;


`endif // GPIO_UVC_TYPES_SV 
