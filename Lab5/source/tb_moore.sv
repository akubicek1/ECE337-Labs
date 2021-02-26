// $Id: $
// File name:   tb_moore.sv
// Created:     2/25/2021
// Author:      Adam Kubicek
// Lab Section: 337-008
// Version:     1.0  Initial Design Entry
// Description: Test bench for moore machine '1101' detector

`timescale 1ns / 10ps

module tb_moore();

    // Define parameters
    // Common parameters
    localparam CLK_PERIOD        = 2.5;
    localparam PROPAGATION_DELAY = 1.0; // Allow for 1000 ps for FF propagation delay

    localparam  INACTIVE_VALUE     = 1'b1;
    localparam  SR_SIZE_BITS       = 8;
    localparam  SR_MAX_BIT         = SR_SIZE_BITS - 1;
    localparam  RESET_OUTPUT_VALUE = 1'b0;

    // Declare Test Case Signals
    integer tb_test_num;
    string  tb_test_case;
    string  tb_stream_check_tag;
    integer tb_bit_num;
    logic   tb_mismatch;
    logic   tb_check;

    // Declare the Test Bench Signals for Expected Results
    logic                   tb_expected_ouput;
    logic  [SR_MAX_BIT:0]   tb_expected_stream;
    logic  [SR_MAX_BIT:0]   tb_test_data;

    // Declare DUT Connection Signals
    logic                tb_clk;
    logic                tb_n_rst;
    logic                tb_i;
    logic                tb_o;

    // Task for standard DUT reset procedure
    task reset_dut;
    begin
        // Activate the reset
        tb_n_rst = 1'b0;
        tb_i = 1'b0;

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

    // Task to cleanly and consistently check DUT output values
    task check_output;
    input string check_tag;
    begin
        tb_mismatch = 1'b0;
        tb_check    = 1'b1;
        #(PROPAGATION_DELAY);
        if(tb_expected_ouput == tb_o) begin // Check passed
            $info("Correct detector output %s during %s test case", check_tag, tb_test_case);
        end
        else begin // Check failed
            tb_mismatch = 1'b1;
            $error("Incorrect detector output %s during %s test case", check_tag, tb_test_case);
        end

        // Wait some small amount of time so check pulse timing is visible on waves
        #(0.1);
        tb_check =1'b0;
    end
    endtask

    // Task to contiguosly send a stream of bits through the moore '1101' detector
    task send_stream;
    input logic [SR_MAX_BIT:0] bits_to_stream;
    begin
        // Coniguously stream out all of the bits in the provided input vector
        for(tb_bit_num = 0; tb_bit_num < SR_SIZE_BITS; tb_bit_num++) begin
            // Update the input
            @(negedge tb_clk);
            tb_i = bits_to_stream[SR_MAX_BIT - tb_bit_num];
            @(posedge tb_clk);
            tb_expected_ouput = tb_expected_stream[SR_MAX_BIT - tb_bit_num];
            // Check that the correct value was sent out for this bit
            $sformat(tb_stream_check_tag, "during bit %0d", tb_bit_num);
            
            check_output(tb_stream_check_tag);
            // Advance to the next bit
        end
    end
    endtask

    // Clock generation block
    always begin
        // Start with clock low to avoid false rising edge events at t=0
        tb_clk = 1'b0;
        // Wait half of the clock period before toggling clock value (maintain 50% duty cycle)
        #(CLK_PERIOD/2.0);
        tb_clk = 1'b1;
        // Wait half of the clock period before toggling clock value via rerunning the block (maintain 50% duty cycle)
        #(CLK_PERIOD/2.0);
    end

    // DUT Portmap
    moore DUT (.clk(tb_clk), .n_rst(tb_n_rst),
                    .i(tb_i),
                    .o(tb_o));
    
    // Test bench main process
    initial begin
        // Initialize all of the test inputs
        tb_n_rst            = 1'b1; // Initialize to be inactive
        tb_i                = 1'b1; // Initialize to be reset value
        tb_test_num         = 0;    // Initialize test case counter
        tb_test_case        = "Test bench initializaton";
        tb_stream_check_tag = "N/A";
        tb_bit_num          = -1;   // Initialize to invalid number
        tb_mismatch         = 1'b0;
        tb_check            = 1'b0;
        // Wait some time before starting first test case
        #(0.1);

        // ************************************************************************
        // Test Case 1: Power-on Reset of the DUT
        // ************************************************************************
        tb_test_num  = tb_test_num + 1;
        tb_test_case = "Power on Reset";
        // Note: Do not use reset task during reset test case since we need to specifically check behavior during reset
        // Wait some time before applying test case stimulus
        #(0.1);
        // Apply test case initial stimulus (non-reset value parralel input)
        tb_test_data = 8'b00001101;
        tb_expected_stream = 8'b00000001;
        send_stream(tb_test_data);
        @(negedge tb_clk);
        tb_expected_ouput = RESET_OUTPUT_VALUE;
        tb_n_rst = 1'b0;

        // Wait for a bit before checking for correct functionality
        #(CLK_PERIOD * 0.5);

        // Check that internal state was correctly reset
        check_output("after reset applied");

        // Check that the reset value is maintained during a clock cycle
        #(CLK_PERIOD);
        check_output("after clock cycle while in reset");
    
        // Release the reset away from a clock edge
        @(negedge tb_clk);
        tb_n_rst  = 1'b1;   // Deactivate the chip reset
        // Check that internal state was correctly keep after reset release
        #(PROPAGATION_DELAY);
        check_output("after reset was released");

        // ************************************************************************
        // Test Case 2: Idle to '1' to Idle to '11' to Idle
        // ************************************************************************
        tb_test_num  = tb_test_num + 1;
        tb_test_case = "Idle to '1' to Idle to '11' to Idle";
        // Note: Do not use reset task during reset test case since we need to specifically check behavior during reset
        // Wait some time before applying test case stimulus
        reset_dut();
        #(CLK_PERIOD);
        // Apply test case initial stimulus (non-reset value parralel input)
        tb_test_data = 8'b01011000;
        tb_expected_stream = 8'b00000000;
        send_stream(tb_test_data);

        // Wait for a bit before checking for correct functionality
        #(CLK_PERIOD * 0.5);

        // Check that internal state was correctly reset
        tb_expected_ouput = RESET_OUTPUT_VALUE;
        check_output("after test");

        // ************************************************************************
        // Test Case 3: Idle to '110' to Idle
        // ************************************************************************
        tb_test_num  = tb_test_num + 1;
        tb_test_case = "Idle to '110' to Idle";
        // Note: Do not use reset task during reset test case since we need to specifically check behavior during reset
        // Wait some time before applying test case stimulus
        reset_dut();
        #(CLK_PERIOD);
        // Apply test case initial stimulus (non-reset value parralel input)
        tb_test_data = 8'b01100000;
        tb_expected_stream = 8'b00000000;
        send_stream(tb_test_data);

        // Wait for a bit before checking for correct functionality
        #(CLK_PERIOD * 0.5);

        // Check that internal state was correctly reset
        tb_expected_ouput = RESET_OUTPUT_VALUE;
        check_output("after test");

        // ************************************************************************
        // Test Case 4: Idle to '1101' to Idle
        // ************************************************************************
        tb_test_num  = tb_test_num + 1;
        tb_test_case = "Idle to '1101' to Idle";
        // Note: Do not use reset task during reset test case since we need to specifically check behavior during reset
        // Wait some time before applying test case stimulus
        reset_dut();
        #(CLK_PERIOD);
        // Apply test case initial stimulus (non-reset value parralel input)
        tb_test_data = 8'b01101000;
        tb_expected_stream = 8'b00001000;
        send_stream(tb_test_data);

        // Wait for a bit before checking for correct functionality
        #(CLK_PERIOD * 0.5);

        // Check that internal state was correctly reset
        tb_expected_ouput = RESET_OUTPUT_VALUE;
        check_output("after test");

        // ************************************************************************
        // Test Case 5: Repeated '1101's
        // ************************************************************************
        tb_test_num  = tb_test_num + 1;
        tb_test_case = "Repeated '1101's";
        // Note: Do not use reset task during reset test case since we need to specifically check behavior during reset
        // Wait some time before applying test case stimulus
        reset_dut();
        #(CLK_PERIOD);
        // Apply test case initial stimulus (non-reset value parralel input)
        tb_test_data = 8'b11011010;
        tb_expected_stream = 8'b00010010;
        send_stream(tb_test_data);

        // Wait for a bit before checking for correct functionality
        #(CLK_PERIOD * 0.5);

        // Check that internal state was correctly reset
        tb_expected_ouput = RESET_OUTPUT_VALUE;
        check_output("after test");

        // ************************************************************************
        // Test Case 6: '1101' to '11' to '11' to Idle
        // ************************************************************************
        tb_test_num  = tb_test_num + 1;
        tb_test_case = "'1101' to '11' to '11'to Idle";
        // Note: Do not use reset task during reset test case since we need to specifically check behavior during reset
        // Wait some time before applying test case stimulus
        reset_dut();
        #(CLK_PERIOD);
        // Apply test case initial stimulus (non-reset value parralel input)
        tb_test_data = 8'b11011100;
        tb_expected_stream = 8'b00010000;
        send_stream(tb_test_data);

        // Wait for a bit before checking for correct functionality
        #(CLK_PERIOD * 0.5);

        // Check that internal state was correctly reset
        tb_expected_ouput = RESET_OUTPUT_VALUE;
        check_output("after test");

        // ************************************************************************
        // Test Case 7: '1's only
        // ************************************************************************
        tb_test_num  = tb_test_num + 1;
        tb_test_case = "'1's only";
        // Note: Do not use reset task during reset test case since we need to specifically check behavior during reset
        // Wait some time before applying test case stimulus
        reset_dut();
        #(CLK_PERIOD);
        // Apply test case initial stimulus (non-reset value parralel input)
        tb_test_data = 8'b11111111;
        tb_expected_stream = 8'b00000000;
        send_stream(tb_test_data);

        // Wait for a bit before checking for correct functionality
        #(CLK_PERIOD * 0.5);

        // Check that internal state was correctly reset
        tb_expected_ouput = RESET_OUTPUT_VALUE;
        check_output("after test");

        // ************************************************************************
        // Test Case 8: '10101010'
        // ************************************************************************
        tb_test_num  = tb_test_num + 1;
        tb_test_case = "'10101010'";
        // Note: Do not use reset task during reset test case since we need to specifically check behavior during reset
        // Wait some time before applying test case stimulus
        reset_dut();
        #(CLK_PERIOD);
        // Apply test case initial stimulus (non-reset value parralel input)
        tb_test_data = 8'b10101010;
        tb_expected_stream = 8'b00000000;
        send_stream(tb_test_data);

        // Wait for a bit before checking for correct functionality
        #(CLK_PERIOD * 0.5);

        // Check that internal state was correctly reset
        tb_expected_ouput = RESET_OUTPUT_VALUE;
        check_output("after test");

        // ************************************************************************
        // Test Case 9: '01010101'
        // ************************************************************************
        tb_test_num  = tb_test_num + 1;
        tb_test_case = "'01010101'";
        // Note: Do not use reset task during reset test case since we need to specifically check behavior during reset
        // Wait some time before applying test case stimulus
        reset_dut();
        #(CLK_PERIOD);
        // Apply test case initial stimulus (non-reset value parralel input)
        tb_test_data = 8'b01010101;
        tb_expected_stream = 8'b00000000;
        send_stream(tb_test_data);

        // Wait for a bit before checking for correct functionality
        #(CLK_PERIOD * 0.5);

        // Check that internal state was correctly reset
        tb_expected_ouput = RESET_OUTPUT_VALUE;
        check_output("after test");
    end
endmodule