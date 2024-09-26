if (!radar_open) return;

var spr_w = sprite_get_width(spr_player)
var spr_h = sprite_get_height(spr_player)

var y_scale = RES_H / surface_get_height(map_surf)

var radarX = (RES_W / 2) - (surface_get_width(map_surf) * y_scale / 2)

var _px = player_x - spr_w * player_scale / 2
var _py = player_y - spr_h * player_scale / 2

surface_set_target(radar_surf)
draw_clear_alpha(c_black, .7)

draw_surface_ext(map_surf, radarX, 0, y_scale, y_scale, 0, c_white, 1)

with (obj_player) {
	if (player_username == global.server.username) continue

	var other_player_x = screenToTileX(x, y) - 1;
	var other_player_y = screenToTileY(x, y) - 1;
	
	var _opx = other_player_x - spr_w * other.player_scale / 2
	var _opy = other_player_y - spr_h * other.player_scale / 2
	draw_sprite_ext(spr_player, 0, radarX + (_opx * y_scale), _opy * y_scale, other.player_scale * y_scale, other.player_scale * y_scale, 0, c_green, 1)
}

draw_sprite_ext(spr_player, 0, radarX + (_px * y_scale), _py * y_scale, player_scale * y_scale, player_scale * y_scale, 0, c_white, 1)

surface_reset_target()
draw_surface(radar_surf, 0, 0)