/**
 * Modified by:
 * 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Grzegorz Lis, Karolina Sawosz
 *
 */

 `timescale 1 ns / 1 ps

module top(
    input  logic clk60MHz,
    input  logic rst,
    input  logic player1_choose,
    input  logic player2_choose,
    output logic player1_led,
    output logic player2_led,
    input  logic in_player1_ready,
    output logic out_player1_ready,
    input  logic in_player2_ready,
    output logic out_player2_ready,
    input  logic [4:0] in_power,
    output logic [4:0] out_power,
    input  logic in_throw_flag,
    output logic out_throw_flag,
    output logic [3:0] r,
    output logic [3:0] g,
    output logic [3:0] b,
    output logic hs,
    output logic vs,
    inout  logic ps2_clk,
    inout  logic ps2_data
);

logic throw_flag;
logic [1:0]current_player;
logic left, win, loose;
logic end_throw;
logic [2:0] wind, turn;
logic [4:0] power;
logic [4:0] speed;
logic [6:0] hp_player1, hp_player2;
logic [11:0] xpos, ypos, xpos_particle, ypos_particle, ypos_prebuff;
logic [11:0] address_particle, address_crate, address_doghouse;
logic [11:0] address_cat, address_cat1, address_cat2, address_cat3;
logic [11:0] address_dog, address_dog1, address_dog2, address_dog3;
logic [11:0] rgb_crate, rgb_doghouse, rgb_particle;
logic [11:0] rgb_cat, rgb_cat1, rgb_cat2, rgb_cat3;
logic [11:0] rgb_dog, rgb_dog1, rgb_dog2, rgb_dog3;

vga_if vga_if_timing_bg();
vga_if vga_if_bg_cat();
vga_if vga_if_cat_crate();
vga_if vga_if_crate_dog();
vga_if vga_if_dog_doghouse();
vga_if vga_if_doghouse_particle();
vga_if vga_if_particle_hp();
vga_if vga_if_hp_power();
vga_if vga_if_power_mouse();
vga_if vga_if_mouse_win();
vga_if vga_if_win_out();

assign vs = vga_if_win_out.vsync;
assign hs = vga_if_win_out.hsync;
assign {r,g,b} = vga_if_win_out.rgb;
assign out_throw_flag = throw_flag;
assign out_power = power;

choose_player u_choose_player(
    .clk60MHz,
    .rst,
    .in_player1_ready,
    .out_player1_ready,
    .in_player2_ready,
    .out_player2_ready,
    .player1_led,
    .player2_led,
    .player1_choose,
    .player2_choose,
    .current_player
);

turn_manager u_turn_manager(
    .clk60MHz,
    .rst,
    .throw_flag,
    .in_throw_flag,
    .current_player,
    .turn
);

set_wind u_set_wind(
    .clk60MHz,
    .rst,
    .turn,
    .wind
);

MouseCtl u_MouseCtl (
    .clk(clk60MHz),
    .rst,
    .ps2_clk(ps2_clk),
    .ps2_data(ps2_data),
    .xpos(xpos),
    .ypos(ypos),
    .left,

    .zpos(),
    .middle(),
    .right(),
    .new_event(),
    .value('0),
    .setx('0),
    .sety('0),
    .setmax_x('0),
    .setmax_y('0)
    );

throw u_throw(
    .clk60MHz,
    .rst,
    .left,
    .power,
    .throw_flag,
    .end_throw,
    .turn(turn[0]),
    .current_player
);

vga_timing u_vga_timing(
    .clk60MHz,
    .rst,
    .out(vga_if_timing_bg)
);

set_speed u_set_speed(
    .clk60MHz,
    .rst,
    .turn(turn[0]),
    .current_player,
    .in_power,
    .power,
    .speed,
    .wind
);

set_ypos u_set_ypos(
    .clk60MHz,
    .rst,
    .in_throw_flag,
    .current_player,
    .throw_flag,
    .ypos_prebuff,
    .end_throw
);

simulate u_simulate(
    .clk60MHz,
    .rst,
    .in_throw_flag,
    .current_player,
    .throw_flag,
    .speed,
    .turn(turn[0]),
    .end_throw,
    .ypos_prebuff,
    .xpos_particle,
    .ypos_particle,
    .hp_player1,
    .hp_player2,
    .win,
    .loose
);

draw_background u_draw_background(
    .clk60MHz,
    .rst,
    .in(vga_if_timing_bg),
    .out(vga_if_bg_cat)
);

cat_rom u_cat_rom(
    .clk60MHz,
    .address(address_cat),
    .address1(address_cat1),
    .address2(address_cat2),
    .address3(address_cat3),
    .rgb(rgb_cat),
    .rgb1(rgb_cat1),
    .rgb2(rgb_cat2),
    .rgb3(rgb_cat3)
);

draw_cat u_draw_cat(
    .clk60MHz,
    .rst,
    .rgb_pixel(rgb_cat),
    .rgb_pixel1(rgb_cat1),
    .rgb_pixel2(rgb_cat2),
    .rgb_pixel3(rgb_cat3),
    .pixel_addr(address_cat),
    .pixel_addr1(address_cat1),
    .pixel_addr2(address_cat2),
    .pixel_addr3(address_cat3),
    .in(vga_if_bg_cat),
    .out(vga_if_cat_crate)
);

crate_rom u_crate_rom(
    .clk60MHz,
    .address(address_crate),
    .address1(address_doghouse),
    .rgb(rgb_crate),
    .rgb1(rgb_doghouse)
);

draw_crate u_draw_crate(
    .clk60MHz,
    .rst,
    .rgb_pixel(rgb_crate),
    .pixel_addr(address_crate),
    .in(vga_if_cat_crate),
    .out(vga_if_crate_dog)
);

dog_rom u_dog_rom(
    .clk60MHz,
    .address(address_dog),
    .address1(address_dog1),
    .address2(address_dog2),
    .address3(address_dog3),
    .rgb(rgb_dog),
    .rgb1(rgb_dog1),
    .rgb2(rgb_dog2),
    .rgb3(rgb_dog3)
);

draw_dog u_draw_dog(
    .clk60MHz,
    .rst,
    .rgb_pixel(rgb_dog),
    .rgb_pixel1(rgb_dog1),
    .rgb_pixel2(rgb_dog2),
    .rgb_pixel3(rgb_dog3),
    .pixel_addr(address_dog),
    .pixel_addr1(address_dog1),
    .pixel_addr2(address_dog2),
    .pixel_addr3(address_dog3),
    .in(vga_if_crate_dog),
    .out(vga_if_dog_doghouse)
);

draw_doghouse u_draw_doghouse(
    .clk60MHz,
    .rst,
    .rgb_pixel(rgb_doghouse),
    .pixel_addr(address_doghouse),
    .in(vga_if_dog_doghouse),
    .out(vga_if_doghouse_particle)
);

particle_rom u_particle_rom(
    .clk60MHz,
    .address(address_particle),
    .rgb(rgb_particle)
);

draw_particle u_draw_particle(
    .clk60MHz,
    .rst,
    .xpos_particle,
    .ypos_particle,
    .rgb_pixel(rgb_particle),
    .pixel_addr(address_particle),
    .in (vga_if_doghouse_particle),
    .out (vga_if_particle_hp)
);

draw_hp_wind u_draw_hp_wind(
    .clk60MHz,
    .rst,
    .hp_player1,
    .hp_player2,
    .wind,
    .in (vga_if_particle_hp),
    .out (vga_if_hp_power)
);

draw_power u_draw_power(
    .clk60MHz,
    .rst,
    .power,
    .current_player,
    .in (vga_if_hp_power),
    .out (vga_if_power_mouse)
);

draw_mouse u_draw_mouse(
    .clk60MHz,
    .rst,
    .xpos,
    .ypos,
    .in (vga_if_power_mouse),
    .out (vga_if_mouse_win)
);

win_loose u_win_loose(
    .clk60MHz,
    .rst,
    .win,
    .loose,
    .in(vga_if_mouse_win),
    .out(vga_if_win_out)
);

endmodule