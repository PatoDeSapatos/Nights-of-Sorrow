depth = -9999

radar_open = false

map_surf = obj_dungeon_manager.map.surf
radar_surf = surface_create(display_get_width(), display_get_height())
surface_set_target(radar_surf)
draw_clear_alpha(c_black, .7)
surface_reset_target()

player_scale = 0.1

player_x = 0
player_y = 0