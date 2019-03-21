// Top module
module game(CLK_50);
begin
    input CLK_50;
    reg [1:0] arr[0:19][0:9];   // 20 * 10
    wire clk;
    
    // Init the whole screen black
    for(i=0;i<20;i=i+1)
    begin
        for(j=0;j<10;j=j+1)
        begin
            arr[i][j] = 1'b0;
        end
    end

    one_sec_timer timer(
        .clk(CLK_50),
        .clk_out(clk)
    );

    gen_block block(
        .clk(clk),
        .rand('d1),
        .arr(arr)
    );
endmodule


module one_sec_timer(clk, clk_out);
begin
    input clk;
    output clk_out;
    
    // This module flip every one second
    // Unfinished
endmodule


/*
 * This module generates a new block based on the given random module.
 * It also check if the game should be end. If it should, the end_game
 * will be 1'b1, otherwise it will be 1'b0
 */
module gen_block(rand, arr, end_game);
begin
    input rand;
    output arr;
    output end_game;
    
    case(rand)
        'd1:
        begin
            for(i=3;i<7;i=i+1)
            begin
                if(arr[0][i] == 1'b1)
                    end_game <= 1'b1;
                else
                    arr[0][i] = 1'b1;
            end
        end

        'd2:
        begin
            for(i=3;i<6;i=i+1)
            begin
                if(arr[1][i] == 1'b1)
                    end_game <= 1'b1
                else
                    arr[1][i] = 1'b1;
            end
            arr[0][3] = 1'b1;
        end

        'd3:
        begin
            for(i=3;i<6;i=i+1)
            begin
                if(arr[1][i] == 1'b1)
                    end_game <= 1'b1;
                else
                    arr[1][i] = 1'b1;
            end
            arr[0][5] = 1'b1;
        end

        'd4:
        begin
            for(i=4;i<6;i=i+1)
            begin
                if(arr[1][i] == 1'b1)
                    end_game <= 1'b1;
                else
                    arr[1][i] = 1'b1;
            end
            arr[0][4] = 1'b1;
            arr[0][5] = 1'b1;
        end

        'd5:
        begin
            for(i=3;i<5;i=i+1)
            begin
                if(arr[1][i] == 1'b1)
                    end_game <= 1'b1;
                else
                    arr[1][i] = 1'b1;
            end
            arr[0][4] = 1'b1;
            arr[0][5] = 1'b1;
        end

        'd6:
        begin
            for(i=3;i<6;i=i+1)
            begin
                if(arr[1][i] == 1'b1)
                    end_game <= 1'b1;
                else
                    arr[1][i] = 1'b1;
            end
            arr[0][4] = 1'b1;
        end

        'd7:
        begin
            for(i=4;i<6;i=i+1)
            begin
                if(arr[1][i] == 1'b1)
                    end_game <= 1'b1
                else
                    arr[1][i] = 1'b1;
            end
            arr[0][3] = 1'b1;
            arr[0][4] = 1'b1;
        end

        default: end_game <= 1'b0;
    endcase

endmodule