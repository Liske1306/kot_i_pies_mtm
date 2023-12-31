/**
 * 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Grzegorz Lis
 *
 */

`timescale 1 ns / 1 ps

module top_fpga(
    input  wire clk,
    input  wire btnC,
    input  wire [1:0] sw,
    input  wire [7:0] JB,
    output wire [1:0] led,
    output wire Vsync,
    output wire Hsync,
    output wire [3:0] vgaRed,
    output wire [3:0] vgaGreen,
    output wire [3:0] vgaBlue,
    output wire [7:0] JA,
    inout  wire PS2Clk,
    inout  wire PS2Data
);

wire locked;
logic clk100MHz;
logic clk60MHz;

clk_wiz_0 my_clk_wiz_0(
     .clk100MHz(clk100MHz),
     .clk60MHz(clk60MHz),
     .locked(locked),
     .clk(clk)
    );

top u_top (
    .clk60MHz(clk60MHz),
    .rst(btnC),
    .player1_choose(sw[1]),
    .player2_choose(sw[0]),
    .player1_led(led[1]),
    .player2_led(led[0]),
    .in_player1_ready(JB[6]),
    .out_player1_ready(JA[6]),
    .in_player2_ready(JB[5]),
    .out_player2_ready(JA[5]),
    .in_power({JB[7],JB[3:0]}),
    .out_power({JA[7],JA[3:0]}),
    .in_throw_flag(JB[4]),
    .out_throw_flag(JA[4]),
    .r(vgaRed),
    .g(vgaGreen),
    .b(vgaBlue),
    .hs(Hsync),
    .vs(Vsync),
    .ps2_clk(PS2Clk),
    .ps2_data(PS2Data)
);

endmodule
