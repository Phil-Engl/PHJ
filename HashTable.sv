`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ETH Zürich
// Engineer: Philipp Engljähringer
// 
// Create Date: 06/03/2024 01:15:37 PM
// Module Name: HashTable
// Project Name: Partitioned_Hash_Join
// Target Devices: xcvu47p-fsvh2892-2L-e
// Tool Versions: 2022.2
// Description: simple hash table built from BRAM module
// 
// Dependencies: BRAM
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module HashTable #(
    parameter TUPLE_SIZE = 64,
    parameter ROW_BITS = 3, 
    parameter COL_BITS = 1
)(
    input logic clk,
    input logic resetn,
    input logic [63:0] tuple_build,
    input logic [63:0] tuple_probe,
    input logic [31:0] hash_build,
    input logic [31:0] hash_probe,
    input logic input_valid_build,
    input logic input_valid_probe,
    input logic start_probing,
    output logic build_ready,
    output logic probe_ready,
    output logic output_valid,
    output logic [127:0] out_dummy
);

// FÜHR A MODE SIGNAL IH (BUILD AND PROBE) UND MACH DIE INPUTS TUPLE, HASH ETC A WRITE_VERISON UND A READ_VERSION

    integer i;
    integer nextI;
    logic Nready;
	// 32 bits for the counter + tuples_per_row * tuples_size
	localparam DATA_WIDTH = 288;
	localparam NUM_ROWS = 2**ROW_BITS;

    typedef enum integer {Init, Read, Write, Probe_Read} StateType;
    StateType State, nextState;


    logic [ROW_BITS-1:0] raddr;
    logic [ROW_BITS-1:0] waddr;
    logic [DATA_WIDTH-1:0] data;
    logic [DATA_WIDTH-1:0] out_row;
    
    logic [63:0] tuple_tmp;
    logic [ROW_BITS-1:0] address_tmp;

    logic [63:0] tuple_tmp1;
    logic valid_tmp1;

    logic valid_tmp;
    logic we;

    simple_dual_port_ram_single_clock #(
       	.DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ROW_BITS)
    ) dut (
        .clk(clk),
        .raddr(raddr),
        .waddr(waddr),
        .data(data),
        .we(we),
        .out(out_row)
    );


    always_ff@(posedge clk) begin
    	if(~resetn) begin
    		State <= Init;
            i <= 0;
    	end
    	else begin
    		State <= nextState;
    		i <= nextI;
            tuple_tmp <= tuple_tmp1;
            valid_tmp <= valid_tmp1;
    	end
    end


    always_comb begin 
        build_ready <= 1;
        probe_ready <= 1;
        nextI <= i;
        we <= 0;
        data <= '0;
        output_valid <= 0;

	    case(State)
	    	Init: begin
                
                if (i < NUM_ROWS) begin
                    waddr <= i;
                    data <= 0;
                    we <= 1;
                    nextI <= i + 1;
                    nextState <= Init;
                    build_ready <= 0;
                    probe_ready <= 0;
                end else begin
                    nextState <= Read;
                    nextI <= 0; // Reset i for the next reset event
                    probe_ready <= 0;
                end
            end

	        Read: begin
	            
                if (start_probing) begin
                    nextState <= Probe_Read;
                end
	            else if (input_valid_build) begin
	                raddr <= hash_build[ROW_BITS-1:0];
                    waddr <= hash_build[ROW_BITS-1:0];
	            	nextState <= Write;
                    build_ready <= 0;
	            end
                probe_ready <= 0;
                
	        end

            Write: begin
                // VERSUCH DES MIT NAM FOR-LOOP Z MACHA....
                if (out_row[287:256] == 0) begin 
                    data[287:256] <= 32'd1;
                    data[255:192] <= tuple_build;
                    data[191:0] <= '0;
                end
                else if (out_row[287:256] == 1) begin
                    data[287:256] <= 32'd2;
                    data[255:192] <= out_row[255:192];
                    data[191:128] <= tuple_build;
                    data[127:0] <= '0;
                end
                else if (out_row[287:256] == 2) begin
                    data[287:256] <= 32'd3;
                    data[255:128] <= out_row[255:128];
                    data[127:64] <= tuple_build;
                    data[63:0] <= '0;
                end
                else begin
                    data[287:256] <= 32'd4;
                    data[255:64] <= out_row[255:64];
                    data[63:0] <= tuple_build;
                end

                we <= 1;
	            nextState <= Read;
                probe_ready <= 0;
            end

            Probe_Read: begin
                raddr <= hash_probe[ROW_BITS-1:0];
                tuple_tmp1 <= tuple_probe;
                valid_tmp1 <= input_valid_probe;

                if (out_row[223:192] == tuple_tmp[31:0] & (out_row[287:256] > 32'd0)) begin
                    out_dummy[127:64] <= out_row[255:192];
                    out_dummy[63:0] <= tuple_tmp[63:0];
                    output_valid <= 1; 
                end
                else if (out_row[159:128] == tuple_tmp[31:0] & (out_row[287:256] > 32'd1)) begin
                    //out_dummy[127:64] <= out_row[191:128];
                    // VERWEND DEN INDEX-STYLE..!
                    out_dummy[64+:64] <= out_row[191:128];
                    out_dummy[63:0] <= tuple_tmp[63:0];
                    output_valid <= 1; 
                end
                else if (out_row[95:64] == tuple_tmp[31:0] & (out_row[287:256] > 32'd2)) begin
                    out_dummy[127:64] <= out_row[127:64];
                    out_dummy[63:0] <= tuple_tmp[63:0];
                    output_valid <= 1; 
                end
                else if (out_row[31:0] == tuple_tmp[31:0] & (out_row[287:256] > 32'd3)) begin
                    out_dummy[127:64] <= out_row[63:0];
                    out_dummy[63:0] <= tuple_tmp[63:0];
                    output_valid <= 1; 
                end

                nextState <= Probe_Read;
            end

	    endcase
	end
endmodule
