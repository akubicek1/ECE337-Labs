// $Id: $
// File name:   tb_flex_counter_wrapper.sv
// Created:     2/18/2021
// Author:      Adam Kubicek
// Lab Section: 337-008
// Version:     1.0  Initial Design Entry
// Description: Test bench for flex counter wrapper

`timescale 1ns / 10ps

module tb_flex_counter_wrapper();

  // Define local parameters used by the test bench
  localparam  NUM_CNT_BITS  = 8;
  localparam  CLK_PERIOD    = 2.5;
  localparam  FF_SETUP_TIME = 0.190;
  localparam  FF_HOLD_TIME  = 0.100;
  localparam  CHECK_DELAY   = (CLK_PERIOD - FF_SETUP_TIME); // Check right before the setup time starts
  
  // Declare DUT portmap signals
  reg tb_clk;
  reg tb_n_rst;
  reg tb_clear;
  reg tb_count_enable;
  reg [(NUM_CNT_BITS-1):0] tb_rollover_val;
  wire [(NUM_CNT_BITS-1):0] tb_count_out;
  wire tb_rollover_flag;
  
  // Declare test bench signals
  integer tb_test_num;
  string tb_test_case;
  integer tb_stream_test_num;
  string tb_stream_check_tag;
  
  // Task for standard DUT reset procedure
  task reset_dut;
  begin
    // Activate the reset
    tb_n_rst = 1'b0;

    //stop COUNTING
    tb_count_enable = 1'b0;

    // Maintain the reset for more than one cycle
    @(posedge tb_clk);
    @(posedge tb_clk);

    // Wait until safely away from rising edge of the clock before releasing
    @(negedge tb_clk);
    tb_n_rst = 1'b1;

    // Leave out of reset for a couple cycles before allowing other stimulus
    // Wait for negative clock edges, 
    // since inputs to DUT should normally be applied away from rising clock edges
    @(negedge tb_clk);
    @(negedge tb_clk);
  end
  endtask

  // Task for standard clear pulse
  task clear_dut;
  begin
    // Activate the reset
    tb_clear = 1'b1;

    // Maintain the reset for more than one cycle
    @(posedge tb_clk);
    @(posedge tb_clk);

    // Wait until safely away from rising edge of the clock before releasing
    @(negedge tb_clk);
    tb_clear = 1'b0;

    // Leave out of reset for a couple cycles before allowing other stimulus
    // Wait for negative clock edges, 
    // since inputs to DUT should normally be applied away from rising clock edges
    @(negedge tb_clk);
  end
  endtask

  // Task to cleanly and consistently check DUT output values
  task check_output;
    input logic [(NUM_CNT_BITS-1):0] expected_count;
    input logic expected_rollover;
    input string check_tag;
  begin
    if(expected_count == tb_count_out) begin // Check passed
      $info("Correct count output %s during %s test case", check_tag, tb_test_case);
    end
    else begin // Check failed
      $error("Incorrect count output %s during %s test case", check_tag, tb_test_case);
    end
    if(expected_rollover == tb_rollover_flag) begin // Check passed
      $info("Correct rollover flag output %s during %s test case", check_tag, tb_test_case);
    end
    else begin // Check failed
      $error("Incorrect rollover flag output %s during %s test case", check_tag, tb_test_case);
    end
  end
  endtask

  // Clock generation block
  always
  begin
    // Start with clock low to avoid false rising edge events at t=0
    tb_clk = 1'b0;
    // Wait half of the clock period before toggling clock value (maintain 50% duty cycle)
    #(CLK_PERIOD/2.0);
    tb_clk = 1'b1;
    // Wait half of the clock period before toggling clock value via rerunning the block (maintain 50% duty cycle)
    #(CLK_PERIOD/2.0);
  end
  
  // DUT Port map
  flex_counter_wrapper DUT(.clk(tb_clk), .n_rst(tb_n_rst), .clear(tb_clear), .count_enable(tb_count_enable), .rollover_val(tb_rollover_val), .count_out(tb_count_out), .rollover_flag(tb_rollover_flag));
  
    integer for1;
  // Test bench main process
  initial
  begin
    // Initialize all of the test inputs
    tb_n_rst = 1'b1;
    tb_clear = 1'b0;
    tb_count_enable = 1'b0;
    tb_rollover_val = 0;   // Initialize input to 0
    tb_test_num = 0;                // Initialize test case counter
    tb_test_case = "Test bench initializaton";
    tb_stream_test_num = 0;
    tb_stream_check_tag = "N/A";
    // Wait some time before starting first test case
    #(0.1);
    
    // ************************************************************************
    // Test Case 1: Power-on Reset of the DUT
    // ************************************************************************
    tb_test_num = tb_test_num + 1;
    tb_test_case = "Power on Reset";
    // Note: Do not use reset task during reset test case since we need to specifically check behavior during reset
    // Wait some time before applying test case stimulus
    #(0.1);
    // Apply test case initial stimulus
    tb_rollover_val = NUM_CNT_BITS;  // Set to be the the non-reset value
    tb_count_enable = 1'b1;
    @(posedge tb_clk);          //wait for two clock periods so counter can count
    @(posedge tb_clk);
    tb_n_rst  = 1'b0;           // Activate reset
    
    // Wait for a bit before checking for correct functionality
    #(CLK_PERIOD * 0.5);

    // Check that internal state was correctly reset
    check_output('0, 1'b0, 
                  "after reset applied");
    
    // Check that the reset value is maintained during a clock cycle
    #(CLK_PERIOD);
    check_output('0, 1'b0, 
                  "after clock cycle while in reset");
    
    // Release the reset away from a clock edge
    @(posedge tb_clk);
    #(2 * FF_HOLD_TIME);
    tb_n_rst  = 1'b1;   // Deactivate the chip reset
    #0.1;

    // ************************************************************************
    // Test Case 2: Rollover for a rollover value that is not a power of two
    // ************************************************************************    
    @(negedge tb_clk); 
    tb_test_num = tb_test_num + 1;
    tb_test_case = "Rollover for a rollover value that is not a power of two";
    // Start out with inactive value and reset the DUT to isolate from prior tests
    tb_rollover_val = 2 ** NUM_CNT_BITS - 1;  // Set to be the the non-reset value
    tb_count_enable = 1'b0;
    reset_dut();

    // Assign test case stimulus
    tb_rollover_val = 2 ** NUM_CNT_BITS - 1;  // Set to be the the non-reset value
    tb_count_enable = 1'b1;

    // Wait for DUT to process stimulus before checking results
    for(for1 = 0; for1 < (2 ** NUM_CNT_BITS - 1); for1++) begin
    @(posedge tb_clk);
    end 
    @(negedge tb_clk);
    // Check results
    check_output((2 ** NUM_CNT_BITS - 1), 1'b1, "after N-1 posedges");

    // ************************************************************************
    // Test Case 3: Continuous counting
    // ************************************************************************    
    @(negedge tb_clk); 
    tb_test_num = tb_test_num + 1;
    tb_test_case = "Continuous counting";
    // Start out with inactive value and reset the DUT to isolate from prior tests
    tb_rollover_val = 2 ** NUM_CNT_BITS - 1;  // Set to be the the non-reset value
    tb_count_enable = 1'b0;
    reset_dut();

    // Assign test case stimulus
    tb_rollover_val = 2 ** NUM_CNT_BITS - 1;  // Set to be the the non-reset value
    tb_count_enable = 1'b1;

    // Wait for DUT to process stimulus before checking results
    for(for1 = 0; for1 < (2 ** NUM_CNT_BITS - 1); for1++) begin
        #(CLK_PERIOD);
        check_output(for1, 1'b0, "after 1 posedge");
    end
    check_output((2 ** NUM_CNT_BITS - 1), 1'b1, "after 15 posedges");
    
    // ************************************************************************
    // Test Case 4: Discontinuous counting
    // ************************************************************************    
    @(negedge tb_clk); 
    tb_test_num = tb_test_num + 1;
    tb_test_case = "Discontinuous counting";
    // Start out with inactive value and reset the DUT to isolate from prior tests
    tb_rollover_val = (2 ** NUM_CNT_BITS - 1);  // Set to be the the non-reset value
    tb_count_enable = 1'b0;
    reset_dut();

    // Assign test case stimulus
    tb_rollover_val = (2 ** NUM_CNT_BITS - 1);  // Set to be the the non-reset value
    tb_count_enable = 1'b1;

    // Wait for DUT to process stimulus before checking results
    for(for1 = 0; for1 < (2 ** NUM_CNT_BITS - 1); for1++) begin
        #(CLK_PERIOD);
        tb_count_enable = 1'b0;
        #(2 * CLK_PERIOD);
        check_output(for1, 1'b0, "after pause");
        tb_count_enable = 1'b1;
    end

    check_output((2 ** NUM_CNT_BITS - 1), 1'b1, "after N pauses");

    // ************************************************************************
    // Test Case 3: Clear while continuous counting
    // ************************************************************************    
    @(negedge tb_clk); 
    tb_test_num = tb_test_num + 1;
    tb_test_case = "Clear while continuous counting";
    // Start out with inactive value and reset the DUT to isolate from prior tests
    tb_rollover_val = (2 ** NUM_CNT_BITS - 1);  // Set to be the the non-reset value
    tb_count_enable = 1'b0;
    reset_dut();

    // Assign test case stimulus
    tb_rollover_val = (2 ** NUM_CNT_BITS - 1);  // Set to be the the non-reset value
    tb_count_enable = 1'b1;

    // Wait for DUT to process stimulus before checking results
    for(for1 = 0; for1 < ((2 ** NUM_CNT_BITS - 1)); for1++) begin
        #(for1 * CLK_PERIOD);
        check_output(for1, 1'b0, "after posedge");
        tb_clear = 1;
        #(5 * CLK_PERIOD);
        tb_clear = 0;
        check_output(0, 1'b0, "after clear");
    end
    
  end
endmodule