`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ETH Zürich
// Engineer: Philipp Engljähringer
// 
// Create Date: 06/03/2024 01:15:37 PM
// Module Name: Partitioned_Hash_Join
// Project Name: Partitioned_Hash_Join
// Target Devices: xcvu47p-fsvh2892-2L-e
// Tool Versions: 2022.2
// Description: Full Partitioned_Hash_Join module
// 
// Dependencies: murmur_8way, HashTable, DD8_3bit
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Partitioned_Hash_Join#(
    parameter INPUT_SIZE = 64,
    parameter ROW_BITS,
    parameter COL_BITS
    )(

    input logic clk,
    input logic resetn,
 
    output logic [7:0] build_in_ready,
    input logic [7:0] [INPUT_SIZE-1:0] build_in,
    input logic [7:0] build_in_valid,

    input logic start_probing,

    output logic [7:0] probe_in_ready,
    input logic [7:0] [INPUT_SIZE-1:0] probe_in,
    input logic [7:0] probe_in_valid,
    
    output logic [7:0] [127:0] ht_out,
    output logic [7:0] ht_out_valid,

    output logic ht_initialized
    );

    logic [7:0] build_out_ready;
    logic [7:0] [INPUT_SIZE-1:0] build_out;
    logic [7:0] [31:0] build_out_tag;
    logic [7:0] build_out_valid;

    logic [7:0] probe_out_ready;
    logic [7:0] [INPUT_SIZE-1:0] probe_out;
    logic [7:0] [31:0] probe_out_tag;
    logic [7:0] probe_out_valid;

    logic [7:0] build_DD8_ready;
    logic [7:0] probe_DD8_ready;

    logic [7:0] [63:0] hashed_build_tuple;
    logic [7:0] [63:0] hashed_probe_tuple;

    logic [7:0] [31:0] build_hash;
    logic [7:0] [31:0] probe_hash;

    logic [7:0] hashed_build_valid;
    logic [7:0] hashed_probe_valid;
    
    logic req_hash = 0;
    logic [INPUT_SIZE - 1:0] in_data;
    logic ready_4_output;
    logic ready_4_input;

murmur_8way murmur_inst_build (
        .clk(clk),
        .resetn(resetn),
        .in_valid(build_in_valid),
        .in_data(build_in),
        .ready_4_input(build_in_ready),
        .ready_4_output(build_DD8_ready),
        .out_valid(hashed_build_valid),
        .out_tuple(hashed_build_tuple),
        .out_tag(build_hash)
    );

murmur_8way murmur_inst_probe (
        .clk(clk),
        .resetn(resetn),
        .in_valid(probe_in_valid),
        .in_data(probe_in),
        .ready_4_input(probe_in_ready),
        .ready_4_output(probe_DD8_ready),
        .out_valid(hashed_probe_valid),
        .out_tuple(hashed_probe_tuple),
        .out_tag(probe_hash)
    );


DD8_3bit #(
    .INPUT_SIZE(INPUT_SIZE),
    .decision_bit(31)
) DD_build (
    .clk(clk),
    .resetn(resetn),

    .in_ready(build_DD8_ready),
    .in(hashed_build_tuple),
    .in_tag(build_hash),
    .in_valid(hashed_build_valid),

    .out_ready(build_out_ready),
    .out(build_out),
    .out_tag(build_out_tag),
    .out_valid(build_out_valid)

  );


  DD8_3bit #(
    .INPUT_SIZE(INPUT_SIZE),
    .decision_bit(31)
  ) DD_probe (
    .clk(clk),
    .resetn(resetn),

    .in_ready(probe_DD8_ready),
    .in(hashed_probe_tuple),
    .in_tag(probe_hash),
    .in_valid(hashed_probe_valid),

    .out_ready(probe_out_ready),
    .out(probe_out),
    .out_tag(probe_out_tag),
    .out_valid(probe_out_valid)

  );

genvar i;

for (i =0; i<8; i=i+1) begin

    HashTable #(
            .TUPLE_SIZE(INPUT_SIZE),
            .ROW_BITS(ROW_BITS),
            .COL_BITS(COL_BITS)
        ) ht_000 (
            .clk(clk),
            .resetn(resetn),

            .build_ready(build_out_ready[i]),
            .tuple_build(build_out[i]),
            .hash_build(build_out_tag[i]),
            .input_valid_build(build_out_valid[i]),

            .start_probing(start_probing),
            .probe_ready(probe_out_ready[i]),
            .tuple_probe(probe_out[i]),
            .hash_probe(probe_out_tag[i]),
            .input_valid_probe(probe_out_valid[i]),

            .output_valid(ht_out_valid[i]),
            .out_dummy(ht_out[i])
        );
end

always_comb begin
    ht_initialized <= build_out_ready[0] & build_out_ready[1] & build_out_ready[2] & build_out_ready[3] & build_out_ready[4] & build_out_ready[5] & build_out_ready[6] & build_out_ready[7];
    
end

endmodule
