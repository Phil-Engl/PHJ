`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ETH Zürich
// Engineer: Philipp Engljähringer
// 
// Create Date: 06/03/2024 01:15:37 PM
// Module Name: DD4_2bit
// Project Name: Partitioned_Hash_Join
// Target Devices: xcvu47p-fsvh2892-2L-e
// Tool Versions: 2022.2
// Description: module has 4 inputs for tuples and forwards tuples according to the n-th and (n-1)th bit of their hash digest to either of the 4 outputs
// 
// Dependencies: DD4, DD2
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module DD4_2bit#(
    parameter INPUT_SIZE = 64,
    parameter decision_bit = 1
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


    input logic out_00_ready,
    output logic [INPUT_SIZE-1:0] out_00,
    output logic [31:0] out_00_tag,
    output logic out_00_valid,

    input logic out_01_ready,
    output logic [INPUT_SIZE-1:0] out_01,
    output logic [31:0] out_01_tag,
    output logic out_01_valid,

    input logic out_10_ready,
    output logic [INPUT_SIZE-1:0] out_10,
    output logic [31:0] out_10_tag,
    output logic out_10_valid,

    input logic out_11_ready,
    output logic [INPUT_SIZE-1:0] out_11,
    output logic [31:0] out_11_tag,
    output logic out_11_valid
    );

    logic in_00_ready;
    logic [INPUT_SIZE-1:0] in_00;
    logic [31:0] in_00_tag;
    logic in_00_valid;

    logic in_01_ready;
    logic [INPUT_SIZE-1:0] in_01;
    logic [31:0] in_01_tag;
    logic in_01_valid;

    logic in_10_ready;
    logic [INPUT_SIZE-1:0] in_10;
    logic [31:0] in_10_tag;
    logic in_10_valid;

    logic in_11_ready;
    logic [INPUT_SIZE-1:0] in_11;
    logic [31:0] in_11_tag;
    logic in_11_valid;

DD4 #(
    .INPUT_SIZE(INPUT_SIZE),
    .decision_bit(decision_bit)
  ) L1 (
    .clk(clk),
    .resetn(resetn),

    .in_0_ready(in_0_ready),
    .in_0(in_0),
    .in_0_tag(in_0_tag),
    .in_0_valid(in_0_valid),

    .in_1_ready(in_1_ready),
    .in_1(in_1),
    .in_1_tag(in_1_tag),
    .in_1_valid(in_1_valid),

    .in_2_ready(in_2_ready),
    .in_2(in_2),
    .in_2_tag(in_2_tag),
    .in_2_valid(in_2_valid),

    .in_3_ready(in_3_ready),
    .in_3(in_3),
    .in_3_tag(in_3_tag),
    .in_3_valid(in_3_valid),

    .zero_0_ready(in_00_ready),
    .zero_0(in_00),
    .zero_0_tag(in_00_tag),
    .zero_0_valid(in_00_valid),

    .zero_1_ready(in_01_ready),
    .zero_1(in_01),
    .zero_1_tag(in_01_tag),
    .zero_1_valid(in_01_valid),

    .one_0_ready(in_10_ready),
    .one_0(in_10),
    .one_0_tag(in_10_tag),
    .one_0_valid(in_10_valid),

    .one_1_ready(in_11_ready),
    .one_1(in_11),
    .one_1_tag(in_11_tag),
    .one_1_valid(in_11_valid)
  );


  DD2 #(
    .INPUT_SIZE(INPUT_SIZE),
    .decision_bit(decision_bit-1)
)L2_0(
    .clk(clk),
    .resetn(resetn),
    
    .a_ready_4_input(in_00_ready),
    .a_input(in_00),
    .a_tag(in_00_tag),
    .a_valid(in_00_valid),

    .b_ready_4_input(in_01_ready),
    .b_input(in_01),
    .b_tag(in_01_tag),
    .b_valid(in_01_valid),

    .ready_0(out_00_ready),
    .out_0(out_00),
    .tag_0(out_00_tag),
    .valid_0(out_00_valid),

    .ready_1(out_01_ready),
    .out_1(out_01),
    .tag_1(out_01_tag),
    .valid_1(out_01_valid)
);


DD2 #(
    .INPUT_SIZE(INPUT_SIZE),
    .decision_bit(decision_bit-1)
)L2_1(
    .clk(clk),
    .resetn(resetn),
    
    .a_ready_4_input(in_10_ready),
    .a_input(in_10),
    .a_tag(in_10_tag),
    .a_valid(in_10_valid),

    .b_ready_4_input(in_11_ready),
    .b_input(in_11),
    .b_tag(in_11_tag),
    .b_valid(in_11_valid),

    .ready_0(out_10_ready),
    .out_0(out_10),
    .tag_0(out_10_tag),
    .valid_0(out_10_valid),

    .ready_1(out_11_ready),
    .out_1(out_11),
    .tag_1(out_11_tag),
    .valid_1(out_11_valid)
);



endmodule
