`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ETH Zürich
// Engineer: Philipp Engljähringer
// 
// Create Date: 06/03/2024 01:15:37 PM
// Module Name: Gate
// Project Name: Partitioned_Hash_Join
// Target Devices: xcvu47p-fsvh2892-2L-e
// Tool Versions: 2022.2
// Description: module has 2 inputs for tuples and either forwards tuples with n-th bit of the hash digest set to low or to high.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Gate #(
    parameter INPUT_SIZE = 64,
    parameter ID = 0,
    parameter decision_bit = 0
    )(
    input logic clk,
    input logic resetn,
    input logic ready_4_output,

    input logic [INPUT_SIZE-1:0] a_input,
    input logic [INPUT_SIZE-1:0] b_input,

    input logic [31:0] a_tag,
    input logic [31:0] b_tag,

    input logic a_valid,
    input logic b_valid,

    output logic a_ready_4_input,
    output logic b_ready_4_input,

    output logic [INPUT_SIZE-1:0] out,
    output logic [31:0] out_tag,
    output logic output_valid

    );

typedef enum int {Init = 0, Work = 1, Stalled_A = 2, Stalled_B = 3} StateType;
StateType State, nextState;

logic [INPUT_SIZE-1:0] NextOutput;
logic NextOutValid;
logic a_Nready;
logic b_Nready;
logic preference;
logic NextPreference;
logic [31:0] NextOutTag;

always_ff@(posedge clk) begin
    	if(~resetn) begin
    		State <= Init;
            preference <= 0;
            out <= '0;
            output_valid <= 1'b0;
            out_tag <= '0;
        end
    	else begin
            
            if(ready_4_output | ~output_valid) begin
                State <= nextState;
                preference <= NextPreference;
                out <= NextOutput;
                out_tag <= NextOutTag;
                output_valid <= NextOutValid;
            end
            else begin
                State <= State;
                preference <= preference;
                out <= out;
                out_tag <= out_tag;
                output_valid <= output_valid;
            end
    	end
    end


always_comb begin
    NextOutput <= '0;
    NextOutValid <= 1'b0;
    NextOutTag <= '0;

    a_ready_4_input <= (ready_4_output | ~output_valid);
    b_ready_4_input <= (ready_4_output | ~output_valid);

    case(State)
	    Init: begin
            NextPreference <= 1;
            NextOutput <= '0;
            NextOutValid <= 1'b0;
            NextOutTag <= '0;
            nextState <= Work;
        end

        Work: begin
            if (a_valid & b_valid & a_tag[decision_bit] == ID[0] & b_tag[decision_bit] == ID[0]) begin
                    // Input b has currently preference
                    if(preference == 0) begin
                        nextState <= Work;
                        NextOutput <= b_input;
                        NextOutTag <= b_tag;
                        NextOutValid <= 1'b1;
                        NextPreference <= 1;
                        a_ready_4_input <= 1'b0;
                    end
                    // Input a has currently preference
                    else begin
                        nextState <= Work;
                        NextOutput <= a_input;
                        NextOutTag <= a_tag;
                        NextOutValid <= 1'b1;
                        NextPreference <= 0;
                        b_ready_4_input <= 1'b0;
                    end
                end
            // Work to do just for input a
            else if (a_valid & a_tag[decision_bit] == ID[0]) begin  
                NextOutput <= a_input;
                NextOutTag <= a_tag;
                NextOutValid <= 1'b1;
                NextPreference <= 0;
            end
            // Work to do just for input b
            else if (b_valid & b_tag[decision_bit] == ID[0]) begin  
                NextOutput <= b_input;
                NextOutTag <= b_tag;
                NextOutValid <= 1'b1;
                NextPreference <= 1;
            end
        end

    endcase
end

endmodule