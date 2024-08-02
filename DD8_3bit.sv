`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ETH Zürich
// Engineer: Philipp Engljähringer
// 
// Create Date: 06/03/2024 01:15:37 PM
// Module Name: DD8_3bit
// Project Name: Partitioned_Hash_Join
// Target Devices: xcvu47p-fsvh2892-2L-e
// Tool Versions: 2022.2
// Description: module has 8 inputs for tuples and forwards tuples according to the [n-th,(n-1)th,(n-2)th] bit of their hash digest to either of the 8 outputs
// 
// Dependencies: DD8, DD4, DD2
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module DD8_3bit#(
  parameter INPUT_SIZE = 64,
  parameter decision_bit = 31
)
    (

    

    input logic clk,
    input logic resetn,

    output logic [7:0] in_ready,
    input logic [7:0] [INPUT_SIZE-1:0] in,
    input logic [7:0][31:0] in_tag,
    input logic [7:0] in_valid,

   

    input logic [7:0] out_ready,
    output logic [7:0][INPUT_SIZE-1:0] out,
    output logic [7:0][31:0] out_tag,
    output logic [7:0]out_valid

    );



  logic in_00_ready;
 logic [INPUT_SIZE-1:0] in_00;
 logic [31:0] in_00_tag;
 logic in_00_valid;

  logic in_01_ready;
  logic [INPUT_SIZE-1:0] in_01;
  logic [31:0] in_01_tag;
  logic in_01_valid;

  logic in_02_ready;
  logic [INPUT_SIZE-1:0] in_02;
  logic [31:0] in_02_tag;
  logic in_02_valid;

  logic in_03_ready;
  logic [INPUT_SIZE-1:0] in_03;
  logic [31:0] in_03_tag;
  logic in_03_valid;


  logic in_10_ready;
 logic [INPUT_SIZE-1:0] in_10;
 logic [31:0] in_10_tag;
 logic in_10_valid;

  logic in_11_ready;
  logic [INPUT_SIZE-1:0] in_11;
  logic [31:0] in_11_tag;
  logic in_11_valid;

  logic in_12_ready;
  logic [INPUT_SIZE-1:0] in_12;
  logic [31:0] in_12_tag;
  logic in_12_valid;

  logic in_13_ready;
  logic [INPUT_SIZE-1:0] in_13;
  logic [31:0] in_13_tag;
  logic in_13_valid;






DD8 #(
    .INPUT_SIZE(INPUT_SIZE),
    .decision_bit(decision_bit)
  ) L1 (
    .clk(clk),
    .resetn(resetn),

    .in_0_ready(in_ready[0]),
    .in_0(in[0]),
    .in_0_tag(in_tag[0]),
    .in_0_valid(in_valid[0]),

    .in_1_ready(in_ready[1]),
    .in_1(in[1]),
    .in_1_tag(in_tag[1]),
    .in_1_valid(in_valid[1]),

    .in_2_ready(in_ready[2]),
    .in_2(in[2]),
    .in_2_tag(in_tag[2]),
    .in_2_valid(in_valid[2]),

    .in_3_ready(in_ready[3]),
    .in_3(in[3]),
    .in_3_tag(in_tag[3]),
    .in_3_valid(in_valid[3]),


    .in_4_ready(in_ready[4]),
    .in_4(in[4]),
    .in_4_tag(in_tag[4]),
    .in_4_valid(in_valid[4]),

    .in_5_ready(in_ready[5]),
    .in_5(in[5]),
    .in_5_tag(in_tag[5]),
    .in_5_valid(in_valid[5]),

    .in_6_ready(in_ready[6]),
    .in_6(in[6]),
    .in_6_tag(in_tag[6]),
    .in_6_valid(in_valid[6]),

    .in_7_ready(in_ready[7]),
    .in_7(in[7]),
    .in_7_tag(in_tag[7]),
    .in_7_valid(in_valid[7]),




    .zero_0_ready(in_00_ready),
    .zero_0(in_00),
    .zero_0_tag(in_00_tag),
    .zero_0_valid(in_00_valid),

    .zero_1_ready(in_01_ready),
    .zero_1(in_01),
    .zero_1_tag(in_01_tag),
    .zero_1_valid(in_01_valid),

    .zero_2_ready(in_02_ready),
    .zero_2(in_02),
    .zero_2_tag(in_02_tag),
    .zero_2_valid(in_02_valid),

    .zero_3_ready(in_03_ready),
    .zero_3(in_03),
    .zero_3_tag(in_03_tag),
    .zero_3_valid(in_03_valid),


    .one_0_ready(in_10_ready),
    .one_0(in_10),
    .one_0_tag(in_10_tag),
    .one_0_valid(in_10_valid),

    .one_1_ready(in_11_ready),
    .one_1(in_11),
    .one_1_tag(in_11_tag),
    .one_1_valid(in_11_valid),

    .one_2_ready(in_12_ready),
    .one_2(in_12),
    .one_2_tag(in_12_tag),
    .one_2_valid(in_12_valid),

    .one_3_ready(in_13_ready),
    .one_3(in_13),
    .one_3_tag(in_13_tag),
    .one_3_valid(in_13_valid)

    
  );




DD4_2bit #(
    .INPUT_SIZE(INPUT_SIZE),
    .decision_bit(decision_bit-1)
  ) L2_0 (
    .clk(clk),
    .resetn(resetn),

    .in_0_ready(in_00_ready),
    .in_0(in_00),
    .in_0_tag(in_00_tag),
    .in_0_valid(in_00_valid),

    .in_1_ready(in_01_ready),
    .in_1(in_01),
    .in_1_tag(in_01_tag),
    .in_1_valid(in_01_valid),

    .in_2_ready(in_02_ready),
    .in_2(in_02),
    .in_2_tag(in_02_tag),
    .in_2_valid(in_02_valid),

    .in_3_ready(in_03_ready),
    .in_3(in_03),
    .in_3_tag(in_03_tag),
    .in_3_valid(in_03_valid),

    .out_00_ready(out_ready[0]),
    .out_00(out[0]),
    .out_00_tag(out_tag[0]),
    .out_00_valid(out_valid[0]),

    .out_01_ready(out_ready[1]),
    .out_01(out[1]),
    .out_01_tag(out_tag[1]),
    .out_01_valid(out_valid[1]),

    .out_10_ready(out_ready[2]),
    .out_10(out[2]),
    .out_10_tag(out_tag[2]),
    .out_10_valid(out_valid[2]),

    .out_11_ready(out_ready[3]),
    .out_11(out[3]),
    .out_11_tag(out_tag[3]),
    .out_11_valid(out_valid[3])
  );


  DD4_2bit #(
    .INPUT_SIZE(INPUT_SIZE),
    .decision_bit(decision_bit-1)
  ) L2_1 (
    .clk(clk),
    .resetn(resetn),

    .in_0_ready(in_10_ready),
    .in_0(in_10),
    .in_0_tag(in_10_tag),
    .in_0_valid(in_10_valid),

    .in_1_ready(in_11_ready),
    .in_1(in_11),
    .in_1_tag(in_11_tag),
    .in_1_valid(in_11_valid),

    .in_2_ready(in_12_ready),
    .in_2(in_12),
    .in_2_tag(in_12_tag),
    .in_2_valid(in_12_valid),

    .in_3_ready(in_13_ready),
    .in_3(in_13),
    .in_3_tag(in_13_tag),
    .in_3_valid(in_13_valid),

    .out_00_ready(out_ready[4]),
    .out_00(out[4]),
    .out_00_tag(out_tag[4]),
    .out_00_valid(out_valid[4]),

    .out_01_ready(out_ready[5]),
    .out_01(out[5]),
    .out_01_tag(out_tag[5]),
    .out_01_valid(out_valid[5]),

    .out_10_ready(out_ready[6]),
    .out_10(out[6]),
    .out_10_tag(out_tag[6]),
    .out_10_valid(out_valid[6]),

    .out_11_ready(out_ready[7]),
    .out_11(out[7]),
    .out_11_tag(out_tag[7]),
    .out_11_valid(out_valid[7])
  );
endmodule
