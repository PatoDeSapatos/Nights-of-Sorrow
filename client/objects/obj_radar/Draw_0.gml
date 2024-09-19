var radarX = global.camera.camera_x + global.camera.camera_w - (surface_get_width(map_surf) / 2)
var radarY = global.camera.camera_y

surface_set_target(radar_surf)
draw_clear_alpha(c_black, 0);

draw_surface(map_surf, 0, 0)

var player_x = screenToTileX(global.camera.follow.x, global.camera.follow.y)
var player_y = screenToTileY(global.camera.follow.x, global.camera.follow.y)

draw_sprite_ext(spr_player, 0, player_x, player_y, 0.2, 0.2, 0, c_white, 1)

surface_reset_target()
draw_surface_ext(radar_surf, radarX, radarY, 0.5, 0.5, 0, c_white, 1)