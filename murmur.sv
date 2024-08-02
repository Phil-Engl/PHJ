`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ETH Zürich
// Engineer: Philipp Engljähringer
// 
// Create Date: 06/03/2024 01:15:37 PM
// Module Name: murmur
// Project Name: Partitioned_Hash_Join
// Target Devices: xcvu47p-fsvh2892-2L-e
// Tool Versions: 2022.2
// Description: compute murmur hash digest of tuples
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module murmur (
    input logic clk,
    input logic resetn,
    input logic req_hash,
    input logic [63:0] in_data,
    output logic ready_4_input,
    input logic ready_4_output,
    output logic out_valid,
    output logic [95:0] out_data
);

parameter KEY_BITS = 32;
parameter PAYLOAD_BITS = 32;
parameter HASH_BITS = 32;

logic requested1, requested2, requested3, requested4, requested5;
logic [KEY_BITS - 1:0] org_key1, org_key2, org_key3, org_key4, org_key5;
logic [PAYLOAD_BITS - 1:0] org_payload1, org_payload2, org_payload3, org_payload4, org_payload5;
logic [KEY_BITS - 1:0] key1, bitshift_key1, xor_key1;
logic [2*KEY_BITS - 1:0] mult_key1;
logic [KEY_BITS - 1:0] key2, bitshift_key2, xor_key2;
logic [2*KEY_BITS - 1:0] mult_key2;
logic [KEY_BITS - 1:0] key3, bitshift_key3, xor_key3;
logic [HASH_BITS-1:0] hash;

always @(posedge clk) begin
    if (~resetn) begin
        requested1 <= 1'b0;
        requested2 <= 1'b0;
        requested3 <= 1'b0;
        requested4 <= 1'b0;
        requested5 <= 1'b0;
    end else begin
        if(ready_4_output) begin
            xor_key1 <= key1 ^ bitshift_key1;
            mult_key1 <= (KEY_BITS == 32) ? (xor_key1 * 32'h85ebca6b) : (xor_key1 * 64'hff51afd7ed558ccd);
            
            xor_key2 <= key2 ^ bitshift_key2;
            mult_key2 <= (KEY_BITS == 32) ? (xor_key2 * 32'hc2b2ae35) : (xor_key2 * 64'hc4ceb9fe1a85ec53);
            
            xor_key3 <= key3 ^ bitshift_key3;
            
            requested1 <= req_hash;
            requested2 <= requested1;
            requested3 <= requested2;
            requested4 <= requested3;
            requested5 <= requested4;

            org_key1 <= in_data[KEY_BITS-1:0];
            org_key2 <= org_key1;
            org_key3 <= org_key2;
            org_key4 <= org_key3;
            org_key5 <= org_key4;

            org_payload1 <= in_data[PAYLOAD_BITS + KEY_BITS -1: KEY_BITS];
            org_payload2 <= org_payload1;
            org_payload3 <= org_payload2;
            org_payload4 <= org_payload3;
            org_payload5 <= org_payload4;

            out_valid <= requested5;
            out_data <= {xor_key3[HASH_BITS-1:0], org_payload5, org_key5};
        end
        else begin
            out_valid <= out_valid;
            out_data <= out_data;
            
        end
    end
end


// USE ALWAYS_COMB, wenns ned lauft denn stimmt din code ned....
// DES MUSS IRGENDWIA FUNKTIONIERA::!!!!!
// FALLS ZU VIEL ZIT VERLÜRSCH, NIMM EINFACH DA ALWAYS@*

always @* begin
//always_comb begin
        key1 <= in_data[KEY_BITS-1:0];
        bitshift_key1 <= (KEY_BITS == 32) ? (key1 >> 16) : (key1 >> 33);;

        key2 <= mult_key1[KEY_BITS-1:0];
        bitshift_key2 <= (KEY_BITS == 32) ? (key2 >> 13) : (key2 >> 33);

        key3 <= mult_key2[KEY_BITS-1:0];
        bitshift_key3 <= (KEY_BITS == 32) ? (key3 >> 16) : (key3 >> 33);;
end

// USE ASSIGN HERE..!
always_comb begin
    ready_4_input <= ready_4_output;
end

endmodule
