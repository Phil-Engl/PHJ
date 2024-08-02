`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ETH Zürich
// Engineer: Philipp Engljähringer
// 
// Create Date: 06/03/2024 01:15:37 PM
// Module Name: DD2
// Project Name: Partitioned_Hash_Join
// Target Devices: xcvu47p-fsvh2892-2L-e
// Tool Versions: 2022.2
// Description: module has 2 inputs for tuples and forwards tuples according to the n-th bit of their hash digest to either of the 2 outputs
// 
// Dependencies: Gate
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module DD2#(
    parameter INPUT_SIZE = 64,
    parameter decision_bit = 0
)
    
    (
    input logic clk,
    input logic resetn,
    
    output logic a_ready_4_input,
    input logic [INPUT_SIZE-1:0] a_input,
    input logic [31:0] a_tag,
    input logic a_valid,

    output logic b_ready_4_input,
    input logic [INPUT_SIZE-1:0] b_input,
    input logic [31:0] b_tag,
    input logic b_valid,

    input logic  ready_0,
    output logic [INPUT_SIZE-1:0] out_0,
    output logic [31:0] tag_0,
    output logic  valid_0,

    input logic  ready_1,
    output logic [INPUT_SIZE-1:0] out_1,
    output logic [31:0] tag_1,
    output logic  valid_1
    );


    logic a0_ready;
    logic b0_ready;

    logic a1_ready;
    logic b1_ready;

    logic a0_valid;
    logic b0_valid;

    logic a1_valid;
    logic b1_valid;

    
    Gate #(
        .INPUT_SIZE(INPUT_SIZE),
        .decision_bit(decision_bit),
        .ID(0)
    ) Gate_0 (
        .clk(clk),
        .resetn(resetn),
        
        .a_ready_4_input(a0_ready),
        .a_input(a_input),
        .a_tag(a_tag),
        .a_valid(a0_valid),

        .b_ready_4_input(b0_ready),
        .b_input(b_input),
        .b_tag(b_tag),
        .b_valid(b0_valid),
        
        .ready_4_output(ready_0),
        .out(out_0),
        .out_tag(tag_0),
        .output_valid(valid_0)
    );


    Gate #(
        .INPUT_SIZE(INPUT_SIZE),
        .decision_bit(decision_bit),
        .ID(1)
    ) Gate_1 (
        .clk(clk),
        .resetn(resetn),
        
        .a_ready_4_input(a1_ready),
        .a_input(a_input),
        .a_tag(a_tag),
        .a_valid(a1_valid),

        .b_ready_4_input(b1_ready),
        .b_input(b_input),
        .b_tag(b_tag),
        .b_valid(b1_valid),
        
        .ready_4_output(ready_1),
        .out(out_1),
        .out_tag(tag_1),
        .output_valid(valid_1)
    );

always_comb begin
    a_ready_4_input <= a0_ready & a1_ready;
    b_ready_4_input <= b0_ready & b1_ready;

    a0_valid <= a_valid & a1_ready;
    a1_valid <= a_valid & a0_ready;

    b0_valid <= b_valid & b1_ready;
    b1_valid <= b_valid & b0_ready;
end

endmodule
