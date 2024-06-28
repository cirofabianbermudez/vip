`ifndef I2C_UVC_MONITOR_SV
`define I2C_UVC_MONITOR_SV

class i2c_uvc_monitor extends uvm_monitor;

  `uvm_component_utils(i2c_uvc_monitor)

  virtual i2c_uvc_if vif;
  i2c_uvc_config     cfg;
  uvm_analysis_port #(i2c_uvc_sequence_item) analysis_port;
  i2c_uvc_sequence_item trans;

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task do_mon();

endclass : i2c_uvc_monitor


function i2c_uvc_monitor::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new


function void i2c_uvc_monitor::build_phase(uvm_phase phase);
  if ( !uvm_config_db #(virtual i2c_uvc_if)::get(get_parent(), "", "vif", vif) ) begin
		  `uvm_fatal(get_name(), "Could not retrieve i2c_uvc_if from config db")
	end

  if ( !uvm_config_db #(i2c_uvc_config)::get(get_parent(), "", "cfg", cfg) ) begin
		  `uvm_fatal(get_name(), "Could not retrieve i2c_uvc_config from config db")
	end

  analysis_port = new("analysis_port", this);

endfunction : build_phase


task i2c_uvc_monitor::run_phase(uvm_phase phase);
  trans = i2c_uvc_sequence_item::type_id::create("trans");
  do_mon();
endtask : run_phase


task i2c_uvc_monitor::do_mon();
  logic [8:0] data_shift_buffer = 'd0;
  logic 

  fork
    begin
      forever begin

        // negedge SDA
        wait (vif.sda_io != 0 && vif.scl_io == 1);
        @(vif.cb_mon iff (vif.sda_io == 0) );
        //$display("[INFO] %4t: negedge SDA detected", $realtime);

        // negedge SCL
        wait (vif.scl_io != 0);
        @(vif.cb_mon iff (vif.scl_io == 0) );
        //$display("[INFO] %4t: negedge SCL detected", $realtime);

        if (vif.scl_io == 1'b0 && vif.scl_io == 1'b0) begin
          //$display("[INFO] %4t: START CONDITION detected", $realtime);
          `uvm_info(get_type_name(), "START CONDITION detected", UVM_MEDIUM)
        end else begin
          continue;
        end

        for (int j = 0; j < 2; j++) begin
          data_shift_buffer = 'd0;
          for (int i = 0; i < 9; i++) begin
            // posedge SCL
            wait (vif.scl_io != 1);
            @(vif.cb_mon iff (vif.scl_io == 1) );
            data_shift_buffer = {data_shift_buffer[7:0], vif.sda_io};

            // negedge SCL
            wait (vif.scl_io != 0);
            @(vif.cb_mon iff (vif.scl_io == 0) );
          end

          //$display("[INFO] %4t: data = 'b%b, ack = 'b%b", $realtime, data_shift_buffer[8:1], data_shift_buffer[0] );

          if (j == 0) begin
            `uvm_info(get_type_name(), $sformatf("address = 'b%b, R/W = 'b%b, ack = 'b%b", data_shift_buffer[8:2], data_shift_buffer[1] ,data_shift_buffer[0] ), UVM_MEDIUM)
          end else begin
            `uvm_info(get_type_name(), $sformatf("data = 'b%b, ack = 'b%b", data_shift_buffer[8:1], data_shift_buffer[0] ), UVM_MEDIUM)
          end
        end

        forever begin
          // posedge SCL
          wait (vif.scl_io != 1 && vif.sda_io == 0);
          @(vif.cb_mon iff (vif.scl_io == 1) );
          //$display("[INFO] %4t: posedge SCL detected", $realtime);

          // negedge SDA
          wait (vif.sda_io != 1);
          @(vif.cb_mon iff (vif.sda_io == 1) );
          //$display("[INFO] %4t: posedge SDA detected", $realtime);

          if (vif.scl_io == 1'b1 && vif.scl_io == 1'b1) begin
            `uvm_info(get_type_name(), "STOP CONDITION detected", UVM_MEDIUM)
            //$display("[INFO] %4t: STOP CONDITION detected", $realtime);
            break;
          end else begin
            continue;
          end

        end




        //`uvm_info(get_type_name(), {"Got item ", trans.convert2string()}, UVM_MEDIUM)
        analysis_port.write(trans);
      end
   end

   begin
     forever begin
        // negedge SDA
        wait (vif.sda_io != 0 && vif.scl_io != 0);
        @(vif.cb_mon iff (vif.sda_io == 0) );
        //$display("[INFO] %4t: negedge SDA detected", $realtime);

        // Detect if SCL is still 1 when negedge of SDA ocurred
        if (vif.scl_io == 0) begin
          continue;
        end

        // negedge SCL
        wait (vif.scl_io != 0);
        @(vif.cb_mon iff (vif.scl_io == 0) );
        //$display("[INFO] %4t: negedge SCL detected", $realtime);

        if (vif.scl_io == 1'b0 && vif.scl_io == 1'b0) begin
          //$display("[INFO] %4t: START CONDITION detected", $realtime);
          `uvm_info(get_type_name(), "******START CONDITION detected", UVM_MEDIUM)
        end else begin
          continue;
        end

     end
   end

   begin
      forever begin
        // posedge SCL
        wait (vif.scl_io != 1 && vif.sda_io != 1);
        @(vif.cb_mon iff (vif.scl_io == 1) );
        //$display("[INFO] %4t: posedge SCL detected", $realtime);

        // Detect if SDA is still 0 when posedge of SCL ocurred
        if (vif.sda_io == 1) begin
          continue;
        end

        // negedge SDA
        wait (vif.sda_io != 1);
        @(vif.cb_mon iff (vif.sda_io == 1) );
        //$display("[INFO] %4t: posedge SDA detected", $realtime);

        if (vif.scl_io == 1'b1 && vif.scl_io == 1'b1) begin
          `uvm_info(get_type_name(), "*******STOP CONDITION detected", UVM_MEDIUM)
          //$display("[INFO] %4t: STOP CONDITION detected", $realtime);
          break;
        end else begin
          continue;
        end

      end
   end

  join

endtask : do_mon



`endif // I2C_UVC_MONITOR_SV
