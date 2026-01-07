`timescale 1ns / 1ps

module anti_bounce_tb;
    // Inputs
    reg btn_in;
    reg clk;

    // Outputs
    wire btn_out;
    wire tick_mf;
    wire [5:0] counter_test;
    wire       btn_stable_test;
    wire       btn_prev_test;

    // Instantiate the freq_divider
    freq_divider #(
        .mf_divider(2),  // Reduced for simulation (100 clock cycles = 1us tick at 100MHz)
        .lf_divider(1000)  // Not used in this test
    ) freq_div (
        .clk_in(clk),
        .tick_mf(tick_mf),
        .tick_lf()         // Not connected
    );

    // Instantiate the Unit Under Test (UUT)
    anti_bounce uut (
        .btn_in(btn_in),
        .tick_mf(tick_mf),
        .clk(clk),
        .btn_out(btn_out),
        .btn_stable_test(btn_stable_test),
        .btn_prev_test(btn_prev_test),
        .counter_test(counter_test)
    );

    // Clock generation (100MHz)
    always #5 clk = ~clk;

    // Test sequence
    initial begin
        // Initialize inputs
        clk = 0;
        btn_in = 0;

        // Wait for global reset
        #100;

        // Test 1: Button press with bounce
        btn_in = 1;
        #450;  // Wait for debounce period (20ms = 20000 ticks at 1kHz)

        // Test 2: Button release with bounce
        btn_in = 0;
        #500;  // Wait for debounce period

        // Test 3: Quick button press and release (shorter than debounce time)
        btn_in = 1;
        #500;    // 5us - shorter than debounce time
        btn_in = 0;
        #100;

        // Test 4: Normal button operation
        btn_in = 1;
        #100;
        btn_in = 0;
        #100;

        // End simulation
        #100000;
        $finish;
    end

    // Monitor signals
    initial begin
        $monitor("Time=%0t, btn_in=%b, tick_mf=%b, btn_out=%b", $time, btn_in, tick_mf, btn_out);
    end

endmodule
