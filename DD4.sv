`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ETH Zürich
// Engineer: Philipp Engljähringer
// 
// Create Date: 06/03/2024 01:15:37 PM
// Module Name: DD4
// Project Name: Partitioned_Hash_Join
// Target Devices: xcvu47p-fsvh2892-2L-e
// Tool Versions: 2022.2
// Description: module has 4 inputs for tuples and forwards tuples according to the n-th bit of their hash digest to either of the 4 outputs
// 
// Dependencies: DD2
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module DD4#(
    parameter INPUT_SIZE = 64,
    parameter decision_bit = 0
    )
    (
    input logic clk,
    input logic resetn,

    output logic in_0_ready,
    input logic [INPUT_SIZE-1:0] in_0,
    input logic [31:0] in_0_tag,
    input logic in_0_valid,

    output logic in_1_ready,
    input logic [INPUT_SIZE-1:0] in_1,
    input logic [31:0] in_1_tag,
    input logic in_1_valid,

    output logic in_2_ready,
    input logic [INPUT_SIZE-1:0] in_2,
    input logic [31:0] in_2_tag,
    input logic in_2_valid,

    output logic in_3_ready,
    input logic [INPUT_SIZE-1:0] in_3,
    input logic [31:0] in_3_tag,
    input logic in_3_valid,

    input logic zero_0_ready,
    output logic [INPUT_SIZE-1:0] zero_0,
    output logic [31:0] zero_0_tag,
    output logic zero_0_valid,

    input logic zero_1_ready,
    output logic [INPUT_SIZE-1:0] zero_1,
    output logic [31:0] zero_1_tag,
    output logic zero_1_valid,

    input logic one_0_ready,
    output logic [INPUT_SIZE-1:0] one_0,
    output logic [31:0] one_0_tag,
    output logic one_0_valid,

    input logic one_1_ready,
    output logic [INPUT_SIZE-1:0] one_1,
    output logic [31:0] one_1_tag,
    output logic one_1_valid
    );


DD2 #(
    .INPUT_SIZE(INPUT_SIZE),
    .decision_bit(decision_bit)
)DD0(
    .clk(clk),
    .resetn(resetn),
    
    .a_ready_4_input(in_0_ready),
    .a_input(in_0),
    .a_tag(in_0_tag),
    .a_valid(in_0_valid),

    .b_ready_4_input(in_1_ready),
    .b_input(in_1),
    .b_tag(in_1_tag),
    .b_valid(in_1_valid),

    .ready_0(zero_0_ready),
    .out_0(zero_0),
    .tag_0(zero_0_tag),
    .valid_0(zero_0_valid),

    .ready_1(one_0_ready),
    .out_1(one_0),
    .tag_1(one_0_tag),
    .valid_1(one_0_valid)
);


DD2 #(
    .INPUT_SIZE(INPUT_SIZE),
    .decision_bit(decision_bit)
)DD1(
    .clk(clk),
    .resetn(resetn),
    
    .a_ready_4_input(in_2_ready),
    .a_input(in_2),
    .a_tag(in_2_tag),
    .a_valid(in_2_valid),

    .b_ready_4_input(in_3_ready),
    .b_input(in_3),
    .b_tag(in_3_tag),
    .b_valid(in_3_valid),

    .ready_0(zero_1_ready),
    .out_0(zero_1),
    .tag_0(zero_1_tag),
    .valid_0(zero_1_valid),

    .ready_1(one_1_ready),
    .out_1(one_1),
    .tag_1(one_1_tag),
    .valid_1(one_1_valid)
);

endmodule
