`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/02/2024 01:15:37 PM
// Design Name: 
// Module Name: HT_8way_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module PHJ_tb;

   parameter INPUT_SIZE = 64;
   parameter COL_BITS = 2;

   parameter ROW_BITS = 21; // 21 for zipf with 8mil
   integer dummy_insert = 10;

    logic clk;
    logic resetn;

    logic [7:0] build_in_ready;
    logic [7:0] [INPUT_SIZE-1:0] build_in;
    logic [7:0] [31:0] build_in_tag;
    logic [7:0] build_in_valid;

    logic [7:0] probe_in_ready;
    logic [7:0] [INPUT_SIZE-1:0] probe_in;
    logic [7:0] [31:0] probe_in_tag;
    logic [7:0] probe_in_valid;

    logic [7:0][127:0] ht_out;
    logic [7:0] ht_out_valid;

    logic ht_initialized;
    logic start_probing = 0;

    Partitioned_Hash_Join #(
        .INPUT_SIZE(INPUT_SIZE),
        .ROW_BITS(ROW_BITS),
        .COL_BITS(COL_BITS)
    ) uut (
    .clk(clk),
    .resetn(resetn),
    .build_in_ready(build_in_ready),
    .build_in(build_in),
    .build_in_valid(build_in_valid),
    .start_probing(start_probing),

    .probe_in_ready(probe_in_ready),
    .probe_in(probe_in),
    .probe_in_valid(probe_in_valid),

    .ht_out(ht_out),
    .ht_out_valid(ht_out_valid),
    .ht_initialized(ht_initialized)
    );


integer h = 1;
integer i = 1;
integer j = 1;
integer k = 1;
integer l = 1;
integer m = 1;
integer n = 1;
integer o = 1;

int  file [7:0];
string line[7:0];
bit [7:0] [63:0] hex_number;
int r [7:0];

int  out_file [7:0];
string path_prefix = "/scratch/phil/";

   // Clock generation
    always #5 clk = ~clk;

    // Initial block
    initial begin
        file[0] = $fopen({path_prefix, "build_tuples_0.txt"}, "r");
        file[1] = $fopen({path_prefix, "build_tuples_1.txt"}, "r");
        file[2] = $fopen({path_prefix, "build_tuples_2.txt"}, "r");
        file[3] = $fopen({path_prefix, "build_tuples_3.txt"}, "r");
        file[4] = $fopen({path_prefix, "build_tuples_4.txt"}, "r");
        file[5] = $fopen({path_prefix, "build_tuples_5.txt"}, "r");
        file[6] = $fopen({path_prefix, "build_tuples_6.txt"}, "r");
        file[7] = $fopen({path_prefix, "build_tuples_7.txt"}, "r");

        clk = 0;
        resetn = 0;
        repeat (5) @(posedge clk);
        
        resetn <= 1;
        build_in_valid[0] <= 0;
        build_in_valid[1] <= 0;
        build_in_valid[2] <= 0;
        build_in_valid[3] <= 0;
        build_in_valid[4] <= 0;
        build_in_valid[5] <= 0;
        build_in_valid[6] <= 0;
        build_in_valid[7] <= 0;
        
        repeat (5) @(posedge clk);
        @(posedge ht_initialized);
        $display("Start: %t", $time);

        fork
            begin
              while (!$feof(file[0])) begin
                    @(posedge clk)
                    if(build_in_ready[0]) begin
                        
                        // Read a line
                        r[0] = $fgets(line[0], file[0]);
                        if (r[0] == 0) begin
                             // Handle empty line or read error
                             //$display("ERROR: Could not read line from file 0...");
                            continue;
                        end

                        r[0] = $sscanf(line[0], "%h", hex_number[0]);
                        if (r[0] == 1) begin
                            //$display("Read hex number 0: %h", hex_number[0]);
                            build_in[0] <= hex_number[0];
                            build_in_valid[0] <= 1'b1;
                        end
                        else begin
                            // Handle error in parsing the line
                            $display("ERROR: Could not parse line: %s", line[0]);
                        end

                    end
                end

                while (!build_in_ready[0]) begin
                    continue;
                end

                build_in[0] <= '0;
                build_in_valid[0] <= 1'b0;
            end  

            begin
                while (!$feof(file[1])) begin
                
                    @(posedge clk)
                    if(build_in_ready[1]) begin
                        
                        // Read a line
                        r[1] = $fgets(line[1], file[1]);
                        if (r[1] == 0) begin
                             // Handle empty line or read error
                             //$display("ERROR: Could not read line from file 1...");
                            continue;
                        end

                        r[1] = $sscanf(line[1], "%h", hex_number[1]);
                        if (r[1] == 1) begin
                            //$display("Read hex number 1: %h", hex_number[1]);
                            build_in[1] <= hex_number[1];
                            build_in_valid[1] <= 1'b1;
                        end
                        else begin
                            // Handle error in parsing the line
                            $display("ERROR: Could not parse line: %s", line[1]);
                        end

                    end
                end

                while (!build_in_ready[1]) begin
                    continue;
                end

                build_in[1] <= '0;
                build_in_valid[1] <= 1'b0;
            end

            begin
                while (!$feof(file[2])) begin
                
                    @(posedge clk)
                    if(build_in_ready[2]) begin
                        
                        // Read a line
                        r[2] = $fgets(line[2], file[2]);
                        if (r[2] == 0) begin
                             // Handle empty line or read error
                             //$display("ERROR: Could not read line from file 2...");
                            continue;
                        end

                        r[2] = $sscanf(line[2], "%h", hex_number[2]);
                        if (r[2] == 1) begin
                            //$display("Read hex number 2: %h", hex_number[2]);
                            build_in[2] <= hex_number[2];
                            build_in_valid[2] <= 1'b1;
                        end
                        else begin
                            // Handle error in parsing the line
                            $display("ERROR: Could not parse line: %s", line[2]);
                        end

                    end
                end

                while (!build_in_ready[2]) begin
                    continue;
                end

                build_in[2] <= '0;
                build_in_valid[2] <= 1'b0;
            end

            begin
                while (!$feof(file[3])) begin
                
                    @(posedge clk)
                    if(build_in_ready[3]) begin
                        
                        // Read a line
                        r[3] = $fgets(line[3], file[3]);
                        if (r[3] == 0) begin
                             // Handle empty line or read error
                             //$display("ERROR: Could not read line from file 3...");
                            continue;
                        end

                        r[3] = $sscanf(line[3], "%h", hex_number[3]);
                        if (r[3] == 1) begin
                            //$display("Read hex number 3: %h", hex_number[3]);
                            build_in[3] <= hex_number[3];
                            build_in_valid[3] <= 1'b1;
                        end
                        else begin
                            // Handle error in parsing the line
                            $display("ERROR: Could not parse line: %s", line[3]);
                        end

                    end
                end

                while (!build_in_ready[3]) begin
                    continue;
                end

                build_in[3] <= '0;
                build_in_valid[3] <= 1'b0;
            end

            begin
                while (!$feof(file[4])) begin
                
                    @(posedge clk)
                    if(build_in_ready[4]) begin
                        
                        // Read a line
                        r[4] = $fgets(line[4], file[4]);
                        if (r[4] == 0) begin
                             // Handle empty line or read error
                             //$display("ERROR: Could not read line from file 4...");
                            continue;
                        end

                        r[4] = $sscanf(line[4], "%h", hex_number[4]);
                        if (r[4] == 1) begin
                            //$display("Read hex number 4: %h", hex_number[4]);
                            build_in[4] <= hex_number[4];
                            build_in_valid[4] <= 1'b1;
                        end
                        else begin
                            // Handle error in parsing the line
                            $display("ERROR: Could not parse line: %s", line[4]);
                        end

                    end
                end

                while (!build_in_ready[4]) begin
                    continue;
                end

                build_in[4] <= '0;
                build_in_valid[4] <= 1'b0;
            end

            begin
                while (!$feof(file[5])) begin
                
                    @(posedge clk)
                    if(build_in_ready[5]) begin
                        
                        // Read a line
                        r[5] = $fgets(line[5], file[5]);
                        if (r[5] == 0) begin
                             // Handle empty line or read error
                             //$display("ERROR: Could not read line from file 5...");
                            continue;
                        end

                        r[5] = $sscanf(line[5], "%h", hex_number[5]);
                        if (r[5] == 1) begin
                            //$display("Read hex number 5: %h", hex_number[5]);
                            build_in[5] <= hex_number[5];
                            build_in_valid[5] <= 1'b1;
                        end
                        else begin
                            // Handle error in parsing the line
                            $display("ERROR: Could not parse line: %s", line[5]);
                        end

                    end
                end

                while (!build_in_ready[5]) begin
                    continue;
                end

                build_in[5] <= '0;
                build_in_valid[5] <= 1'b0;
            end

            begin
                while (!$feof(file[6])) begin
                
                    @(posedge clk)
                    if(build_in_ready[6]) begin
                        
                        // Read a line
                        r[6] = $fgets(line[6], file[6]);
                        if (r[6] == 0) begin
                             // Handle empty line or read error
                             //$display("ERROR: Could not read line from file 6...");
                            continue;
                        end

                        r[6] = $sscanf(line[6], "%h", hex_number[6]);
                        if (r[6] == 1) begin
                            //$display("Read hex number 6: %h", hex_number[6]);
                            build_in[6] <= hex_number[6];
                            build_in_valid[6] <= 1'b1;
                        end
                        else begin
                            // Handle error in parsing the line
                            $display("ERROR: Could not parse line: %s", line[6]);
                        end

                    end
                end

                while (!build_in_ready[6]) begin
                    continue;
                end

                build_in[6] <= '0;
                build_in_valid[6] <= 1'b0;
            end


            begin
                while (!$feof(file[7])) begin
                
                    @(posedge clk)
                    if(build_in_ready[7]) begin
                        
                        // Read a line
                        r[7] = $fgets(line[7], file[7]);
                        if (r[7] == 0) begin
                             // Handle empty line or read error
                             //$display("ERROR: Could not read line from file 7...");
                            continue;
                        end

                        r[7] = $sscanf(line[7], "%h", hex_number[7]);
                        if (r[7] == 1) begin
                            //$display("Read hex number 7: %h", hex_number[7]);
                            build_in[7] <= hex_number[7];
                            build_in_valid[7] <= 1'b1;
                        end
                        else begin
                            // Handle error in parsing the line
                            $display("ERROR: Could not parse line: %s", line[7]);
                        end

                    end
                end

                while (!build_in_ready[7]) begin
                    continue;
                end

                //@(posedge clk)
                build_in[7] <= '0;
                build_in_valid[7] <= 1'b0;
            end


        join
    
    $display("Done: %t", $time);
    repeat (500) @(posedge clk);

    $fclose(file[0]);
    $fclose(file[1]);
    $fclose(file[2]);
    $fclose(file[3]);
    $fclose(file[4]);
    $fclose(file[5]);
    $fclose(file[6]);
    $fclose(file[7]);

    file[0] = $fopen({path_prefix, "probe_tuples_0.txt"}, "r");
    file[1] = $fopen({path_prefix, "probe_tuples_1.txt"}, "r");
    file[2] = $fopen({path_prefix, "probe_tuples_2.txt"}, "r");
    file[3] = $fopen({path_prefix, "probe_tuples_3.txt"}, "r");
    file[4] = $fopen({path_prefix, "probe_tuples_4.txt"}, "r");
    file[5] = $fopen({path_prefix, "probe_tuples_5.txt"}, "r");
    file[6] = $fopen({path_prefix, "probe_tuples_6.txt"}, "r");
    file[7] = $fopen({path_prefix, "probe_tuples_7.txt"}, "r");
    
    repeat (500) @(posedge clk);

    start_probing <= 1;
    h <= 0;
    i <= 0;

    repeat (20) @(posedge clk);

    fork
        begin
            while (!$feof(file[0])) begin
                @(posedge clk)
                if(probe_in_ready[0]) begin
                    // Read a line
                    r[0] = $fgets(line[0], file[0]);
                    if (r[0] == 0) begin
                            // Handle empty line or read error
                            //$display("ERROR: Could not read line from file 0...");
                        continue;
                    end
                    r[0] = $sscanf(line[0], "%h", hex_number[0]);
                    if (r[0] == 1) begin
                        //$display("Read hex number 0: %h", hex_number[0]);
                        probe_in[0] <= hex_number[0];
                        probe_in_valid[0] <= 1'b1;
                    end
                    else begin
                        // Handle error in parsing the line
                        $display("ERROR: Could not parse line: %s", line[0]);
                    end
                end
            end

            while (!probe_in_ready[0]) begin
                continue;
            end

            probe_in[0] <= '0;
            probe_in_valid[0] <= 1'b0;
        end


        begin
            while (!$feof(file[1])) begin
                @(posedge clk)
                if(probe_in_ready[1]) begin
                    // Read a line
                    r[1] = $fgets(line[1], file[1]);
                    if (r[1] == 0) begin
                            // Handle empty line or read error
                            //$display("ERROR: Could not read line from file 0...");
                        continue;
                    end
                    r[1] = $sscanf(line[1], "%h", hex_number[1]);
                    if (r[1] == 1) begin
                        //$display("Read hex number 0: %h", hex_number[1]);
                        probe_in[1] <= hex_number[1];
                        probe_in_valid[1] <= 1'b1;
                    end
                    else begin
                        // Handle error in parsing the line
                        $display("ERROR: Could not parse line: %s", line[1]);
                    end
                end
            end

            while (!probe_in_ready[1]) begin
                continue;
            end

            probe_in[1] <= '0;
            probe_in_valid[1] <= 1'b0;
        end  


        begin
            while (!$feof(file[2])) begin
                @(posedge clk)
                if(probe_in_ready[2]) begin
                    // Read a line
                    r[2] = $fgets(line[2], file[2]);
                    if (r[2] == 0) begin
                            // Handle empty line or read error
                            //$display("ERROR: Could not read line from file 0...");
                        continue;
                    end
                    r[2] = $sscanf(line[2], "%h", hex_number[2]);
                    if (r[2] == 1) begin
                        //$display("Read hex number 0: %h", hex_number[2]);
                        probe_in[2] <= hex_number[2];
                        probe_in_valid[2] <= 1'b1;
                    end
                    else begin
                        // Handle error in parsing the line
                        $display("ERROR: Could not parse line: %s", line[2]);
                    end
                end
            end

            while (!probe_in_ready[2]) begin
                continue;
            end

            probe_in[2] <= '0;
            probe_in_valid[2] <= 1'b0;
        end

        begin
            while (!$feof(file[3])) begin
                @(posedge clk)
                if(probe_in_ready[3]) begin
                    // Read a line
                    r[3] = $fgets(line[3], file[3]);
                    if (r[3] == 0) begin
                            // Handle empty line or read error
                            //$display("ERROR: Could not read line from file 0...");
                        continue;
                    end
                    r[3] = $sscanf(line[3], "%h", hex_number[3]);
                    if (r[3] == 1) begin
                        //$display("Read hex number 0: %h", hex_number[3]);
                        probe_in[3] <= hex_number[3];
                        probe_in_valid[3] <= 1'b1;
                    end
                    else begin
                        // Handle error in parsing the line
                        $display("ERROR: Could not parse line: %s", line[3]);
                    end
                end
            end

            while (!probe_in_ready[3]) begin
                continue;
            end

            probe_in[3] <= '0;
            probe_in_valid[3] <= 1'b0;
        end

        begin
            while (!$feof(file[4])) begin
                @(posedge clk)
                if(probe_in_ready[4]) begin
                    // Read a line
                    r[4] = $fgets(line[4], file[4]);
                    if (r[4] == 0) begin
                            // Handle empty line or read error
                            //$display("ERROR: Could not read line from file 0...");
                        continue;
                    end
                    r[4] = $sscanf(line[4], "%h", hex_number[4]);
                    if (r[4] == 1) begin
                        //$display("Read hex number 0: %h", hex_number[4]);
                        probe_in[4] <= hex_number[4];
                        probe_in_valid[4] <= 1'b1;
                    end
                    else begin
                        // Handle error in parsing the line
                        $display("ERROR: Could not parse line: %s", line[4]);
                    end
                end
            end

            while (!probe_in_ready[4]) begin
                continue;
            end

            probe_in[4] <= '0;
            probe_in_valid[4] <= 1'b0;
        end

        begin
            while (!$feof(file[5])) begin
                @(posedge clk)
                if(probe_in_ready[5]) begin
                    // Read a line
                    r[5] = $fgets(line[5], file[5]);
                    if (r[5] == 0) begin
                            // Handle empty line or read error
                            //$display("ERROR: Could not read line from file 0...");
                        continue;
                    end
                    r[5] = $sscanf(line[5], "%h", hex_number[5]);
                    if (r[5] == 1) begin
                        //$display("Read hex number 0: %h", hex_number[5]);
                        probe_in[5] <= hex_number[5];
                        probe_in_valid[5] <= 1'b1;
                    end
                    else begin
                        // Handle error in parsing the line
                        $display("ERROR: Could not parse line: %s", line[5]);
                    end
                end
            end

            while (!probe_in_ready[5]) begin
                continue;
            end

            probe_in[5] <= '0;
            probe_in_valid[5] <= 1'b0;
        end

        begin
            while (!$feof(file[6])) begin
                @(posedge clk)
                if(probe_in_ready[6]) begin
                    // Read a line
                    r[6] = $fgets(line[6], file[6]);
                    if (r[6] == 0) begin
                            // Handle empty line or read error
                            //$display("ERROR: Could not read line from file 0...");
                        continue;
                    end
                    r[6] = $sscanf(line[6], "%h", hex_number[6]);
                    if (r[6] == 1) begin
                        //$display("Read hex number 0: %h", hex_number[6]);
                        probe_in[6] <= hex_number[6];
                        probe_in_valid[6] <= 1'b1;
                    end
                    else begin
                        // Handle error in parsing the line
                        $display("ERROR: Could not parse line: %s", line[6]);
                    end
                end
            end

            while (!probe_in_ready[6]) begin
                continue;
            end

            probe_in[6] <= '0;
            probe_in_valid[6] <= 1'b0;
        end

        begin
            while (!$feof(file[7])) begin
                @(posedge clk)
                if(probe_in_ready[7]) begin
                    // Read a line
                    r[7] = $fgets(line[7], file[7]);
                    if (r[7] == 0) begin
                            // Handle empty line or read error
                            //$display("ERROR: Could not read line from file 0...");
                        continue;
                    end
                    r[7] = $sscanf(line[7], "%h", hex_number[7]);
                    if (r[7] == 1) begin
                        //$display("Read hex number 0: %h", hex_number[7]);
                        probe_in[7] <= hex_number[7];
                        probe_in_valid[7] <= 1'b1;
                    end
                    else begin
                        // Handle error in parsing the line
                        $display("ERROR: Could not parse line: %s", line[7]);
                    end
                end
            end

            while (!probe_in_ready[7]) begin
                continue;
            end

            probe_in[7] <= '0;
            probe_in_valid[7] <= 1'b0;
        end

    join

    repeat (500) @(posedge clk);

    $fclose(file[0]);
    $fclose(file[1]);
    $fclose(file[2]);
    $fclose(file[3]);
    $fclose(file[4]);
    $fclose(file[5]);
    $fclose(file[6]);
    $fclose(file[7]);
    
    repeat (500) @(posedge clk);
    $finish;
end

    initial begin
        out_file[0] = $fopen({path_prefix, "output_0.txt"}, "w");
        out_file[1] = $fopen({path_prefix, "output_1.txt"}, "w");
        out_file[2] = $fopen({path_prefix, "output_2.txt"}, "w");
        out_file[3] = $fopen({path_prefix, "output_3.txt"}, "w");
        out_file[4] = $fopen({path_prefix, "output_4.txt"}, "w");
        out_file[5] = $fopen({path_prefix, "output_5.txt"}, "w");
        out_file[6] = $fopen({path_prefix, "output_6.txt"}, "w");
        out_file[7] = $fopen({path_prefix, "output_7.txt"}, "w");

        $fmonitor(out_file[0], "%h", ht_out[0]);
        $fmonitor(out_file[1], "%h", ht_out[1]);
        $fmonitor(out_file[2], "%h", ht_out[2]);
        $fmonitor(out_file[3], "%h", ht_out[3]);
        $fmonitor(out_file[4], "%h", ht_out[4]);
        $fmonitor(out_file[5], "%h", ht_out[5]);
        $fmonitor(out_file[6], "%h", ht_out[6]);
        $fmonitor(out_file[7], "%h", ht_out[7]);
    end

    initial begin
        $monitor("HT_out: %h", ht_out[0]);
        $monitor("HT_out: %h", ht_out[1]);
        $monitor("HT_out: %h", ht_out[2]);
        $monitor("HT_out: %h", ht_out[3]);
        $monitor("HT_out: %h", ht_out[4]);
        $monitor("HT_out: %h", ht_out[5]);
        $monitor("HT_out: %h", ht_out[6]);
        $monitor("HT_out: %h", ht_out[7]);
    end

endmodule
