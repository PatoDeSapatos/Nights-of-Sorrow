if (!radar_open) return;

var y_scale = RES_H / surface_get_height(map_surf)

var radarX = (RES_W / 2) - (surface_get_width(map_surf) * y_scale / 2)

var _px = player_x - sprite_get_width(spr_player) * player_scale / 2
var _py = player_y - sprite_get_height(spr_player) * player_scale / 2

surface_set_target(radar_surf)
draw_clear_alpha(c_black, .7)

draw_surface_ext(map_surf, radarX, 0, y_scale, y_scale, 0, c_white, 1)
draw_sprite_ext(spr_player, 0, radarX + (_px * y_scale), _py * y_scale, player_scale * y_scale, player_scale * y_scale, 0, c_white, 1)

surface_reset_target()
draw_surface(radar_surf, 0, 0)