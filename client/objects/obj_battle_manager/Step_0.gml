/// @description
with(obj_battle_unit) {	
	var _bottom_x = screenToTileXG(x, y, other.tile_size, other.init_x, other.init_y) - 1;
	var _bottom_y = screenToTileYG(x, y, other.tile_size, other.init_x, other.init_y) - 1;

	depth = -(tileToScreenYG(_bottom_x, _bottom_y, other.tile_size, other.init_y));
}

if (!animating && mouse_hover.x != -1 && mouse_hover.y != -1) {
	path = get_shortest_path_array(
		grid, 
		player_units[0].unit.position.x, 
		player_units[0].unit.position.y,
		mouse_hover.x,
		mouse_hover.y
	);
	array_insert(path, 0, [player_units[0].unit.position.x, player_units[0].unit.position.y]);
	
	if (array_length(player_units) > 0 && mouse_check_button_pressed(mb_left)) {
		move_unit_path(player_units[0], path);
		path = [];
	}	
}	
