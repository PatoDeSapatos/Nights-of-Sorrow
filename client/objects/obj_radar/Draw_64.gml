if (!radar_open) return;

var y_scale = display_get_height() / surface_get_height(map_surf)

var radarX = (display_get_width() / 2) - (surface_get_width(map_surf) * y_scale / 2)

var _px = player_x - sprite_get_width(spr_player) * player_scale / 2
var _py = player_y - sprite_get_height(spr_player) * player_scale / 2

var map_clone = surface_create(surface_get_width(map_surf), surface_get_height(map_surf))
surface_copy(map_clone, 0, 0, map_surf)

surface_set_target(map_clone)
draw_sprite_ext(spr_player, 0, _px, _py, player_scale, player_scale, 0, c_white, 1)

surface_reset_target()
surface_set_target(radar_surf)
draw_surface_ext(map_clone, radarX, 0, y_scale, y_scale, 0, c_white, 1)

surface_reset_target()
draw_surface(radar_surf, 0, 0)
surface_free(map_clone)