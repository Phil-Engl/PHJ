`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ETH Zürich
// Engineer: Philipp Engljähringer
// 
// Create Date: 06/03/2024 01:15:37 PM
// Module Name: murmur_8way
// Project Name: Partitioned_Hash_Join
// Target Devices: xcvu47p-fsvh2892-2L-e
// Tool Versions: 2022.2
// Description: 8 instances of murmur_module in parallel
// 
// Dependencies: murmur
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module murmur_8way(
    input logic clk,
    input logic resetn,
    input logic [7:0] in_valid,
    input logic [7:0] [63:0] in_data,
    output logic [7:0] ready_4_input,
    input logic [7:0] ready_4_output,
    output logic [7:0] out_valid,
    output logic [7:0] [63:0] out_tuple,
    output logic [7:0] [31:0] out_tag
    );


logic [7:0] [95:0] out_data;
integer i;

for(genvar i=0; i<8; i=i+1) begin
    murmur murmur_inst (
            .clk(clk),
            .resetn(resetn),
            .req_hash(in_valid[i]),
            .in_data(in_data[i]),
            .ready_4_input(ready_4_input[i]),
            .ready_4_output(ready_4_output[i]),
            .out_valid(out_valid[i]),
            .out_data(out_data[i]) // Connect to wire
        );
end


always_comb begin
    for(i=0; i<8; i=i+1) begin
        out_tuple[i] <= out_data[i][63:0];
        out_tag[i] <= out_data[i][95:64];
    end
end



endmodule
