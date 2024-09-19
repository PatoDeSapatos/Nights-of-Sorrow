var radarX = global.camera.camera_x + global.camera.camera_w - (surface_get_width(map_surf))
var radarY = global.camera.camera_y

surface_set_target(radar_surf)
draw_clear_alpha(c_black, 0);

draw_surface(map_surf, 0, 0)

var player_x = screenToTileX(global.camera.follow.x, global.camera.follow.y) - (sprite_get_width(spr_player) * player_scale / 2)
var player_y = screenToTileY(global.camera.follow.x, global.camera.follow.y) - (sprite_get_height(spr_player) * player_scale / 2)

draw_sprite_ext(spr_player, 0, player_x, player_y, player_scale, player_scale, 0, c_white, 1)

surface_reset_target()
draw_surface_ext(radar_surf, radarX, radarY, 1, 1, 0, c_white, 1)