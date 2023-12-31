/**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Karolina Sawosz
 *
 */

`timescale 1 ns / 1 ps

module draw_power(
    input  logic clk60MHz,
    input  logic rst,

    input  logic [4:0] power,
    input  logic [1:0] current_player,

    vga_if.in in,
    vga_if.out out
);

import variable_pkg::*;

logic [11:0] rgb_nxt;

always_ff @(posedge clk60MHz) begin
    if (rst) begin
        out.vcount <= '0;
        out.vsync  <= '0;
        out.vblnk  <= '0;
        out.hcount <= '0;
        out.hsync  <= '0;
        out.hblnk  <= '0;
        out.rgb    <= '0;
    end else begin
        out.vcount <= in.vcount;
        out.vsync  <= in.vsync;
        out.vblnk  <= in.vblnk;
        out.hcount <= in.hcount;
        out.hsync  <= in.hsync;
        out.hblnk  <= in.hblnk;
        out.rgb    <= rgb_nxt;
    end
end

always_comb begin          
    if ((in.hcount >= POWER_PLAYER1_XPOS - power * 4)&&(in.hcount <= POWER_PLAYER1_XPOS)&&(in.vcount >= POWER_YPOS)&&(in.vcount <= POWER_YPOS + POWER_HEIGHT)&&(current_player == PLAYER_1)) begin
        rgb_nxt = 12'he_a_2;
    end
    else if ((in.hcount >= POWER_PLAYER1_XPOS)&&(in.hcount <= POWER_PLAYER1_XPOS + 4)&&(in.vcount >= POWER_YPOS - 4)&&(in.vcount <= POWER_YPOS + POWER_HEIGHT + 4)&&(current_player == PLAYER_1)) begin
        rgb_nxt = 12'h0_0_0;
    end
    else if ((in.hcount >= POWER_PLAYER1_XPOS - 128)&&(in.hcount <= POWER_PLAYER1_XPOS - 124)&&(in.vcount >= POWER_YPOS - 4)&&(in.vcount <= POWER_YPOS + POWER_HEIGHT + 4)&&(current_player == PLAYER_1)) begin
        rgb_nxt = 12'h0_0_0;
    end
    else if ((in.hcount >= POWER_PLAYER1_XPOS - 124)&&(in.hcount <= POWER_PLAYER1_XPOS)&&(in.vcount >= POWER_YPOS - 4)&&(in.vcount <= POWER_YPOS)&&(current_player == PLAYER_1)) begin
        rgb_nxt = 12'h0_0_0;
    end
    else if ((in.hcount >= POWER_PLAYER1_XPOS - 124)&&(in.hcount <= POWER_PLAYER1_XPOS)&&(in.vcount >= POWER_YPOS + POWER_HEIGHT)&&(in.vcount <= POWER_YPOS + POWER_HEIGHT + 4)&&(current_player == PLAYER_1)) begin
        rgb_nxt = 12'h0_0_0;
    end
    else if ((in.hcount >= POWER_PLAYER2_XPOS)&&(in.hcount <= POWER_PLAYER2_XPOS + power * 4)&&(in.vcount >= POWER_YPOS)&&(in.vcount <= POWER_YPOS + POWER_HEIGHT)&&(current_player == PLAYER_2)) begin
        rgb_nxt = 12'he_a_2;
    end
    else if ((in.hcount >= POWER_PLAYER2_XPOS - 4)&&(in.hcount <= POWER_PLAYER2_XPOS)&&(in.vcount >= POWER_YPOS - 4)&&(in.vcount <= POWER_YPOS + POWER_HEIGHT + 4)&&(current_player == PLAYER_2)) begin
        rgb_nxt = 12'h0_0_0;
    end
    else if ((in.hcount >= POWER_PLAYER2_XPOS + 124)&&(in.hcount <= POWER_PLAYER2_XPOS + 128)&&(in.vcount >= POWER_YPOS - 4)&&(in.vcount <= POWER_YPOS + POWER_HEIGHT + 4)&&(current_player == PLAYER_2)) begin
        rgb_nxt = 12'h0_0_0;
    end
    else if ((in.hcount >= POWER_PLAYER2_XPOS)&&(in.hcount <= POWER_PLAYER2_XPOS + 124)&&(in.vcount >= POWER_YPOS - 4)&&(in.vcount <= POWER_YPOS)&&(current_player == PLAYER_2)) begin
        rgb_nxt = 12'h0_0_0;
    end
    else if ((in.hcount >= POWER_PLAYER2_XPOS)&&(in.hcount <= POWER_PLAYER2_XPOS + 124)&&(in.vcount >= POWER_YPOS + POWER_HEIGHT)&&(in.vcount <= POWER_YPOS + POWER_HEIGHT + 4)&&(current_player == PLAYER_2)) begin
        rgb_nxt = 12'h0_0_0;
    end
    else begin
        rgb_nxt = in.rgb;
    end 
end

endmodule
