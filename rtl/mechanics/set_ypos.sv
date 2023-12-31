/**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Grzegorz Lis
 *
 */

module set_ypos(
    input  logic clk60MHz,
    input  logic rst,
    input  logic in_throw_flag,
    input  logic throw_flag,
    input  logic end_throw,
    input  logic [1:0] current_player,
    output logic [11:0] ypos_prebuff
);

import variable_pkg::*;

logic [11:0] ypos_prebuff_nxt;
logic [5:0] speed, speed_nxt;
logic [17:0] counter, counter_nxt;

enum logic [1:0]{
    WAIT = 2'b00,
    UP = 2'b01,
    DOWN = 2'b10
} state, state_nxt;

always_ff @(posedge clk60MHz) begin
    if(rst) begin
        ypos_prebuff <= 769;
        speed        <= 20;
        counter      <= '0;
        state        <= WAIT;
    end
    else begin
        ypos_prebuff <= ypos_prebuff_nxt;
        speed        <= speed_nxt;
        counter      <= counter_nxt;
        state        <= state_nxt;
    end
end

always_comb begin
    case(state)
        WAIT: begin
            if(((throw_flag == 1) || (in_throw_flag == 1)) && ((current_player == PLAYER_1) || (current_player == PLAYER_2)))begin
                state_nxt = UP;
                ypos_prebuff_nxt = 454;
            end
            else begin
                state_nxt = WAIT;
                ypos_prebuff_nxt = 769;
            end
            speed_nxt = 22;
            counter_nxt = '0;
        end
        UP: begin
            if(counter >= 250000)begin
                ypos_prebuff_nxt = ypos_prebuff - speed;
                speed_nxt = speed - 1;
                counter_nxt = '0;
            end
            else begin
                ypos_prebuff_nxt = ypos_prebuff;
                speed_nxt = speed;
                counter_nxt = counter + 1;
            end

            if(speed <= 1) begin
                state_nxt = DOWN;
            end
            else begin
                state_nxt = UP;
            end
        end
        DOWN: begin
            if(counter >= 100000)begin
                ypos_prebuff_nxt = ypos_prebuff + speed;
                speed_nxt = speed + 1;
                counter_nxt = '0;
            end
            else begin
                ypos_prebuff_nxt = ypos_prebuff;
                speed_nxt = speed;
                counter_nxt = counter + 1;
            end

            if(end_throw == 1) begin
                state_nxt = WAIT;
            end
            else begin
                state_nxt = DOWN;
            end
        end
        default: begin
            speed_nxt = 20;
            counter_nxt = '0;
            ypos_prebuff_nxt = 768;
            state_nxt = WAIT;
        end
    endcase
end

endmodule