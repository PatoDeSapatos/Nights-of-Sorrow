/// @description
with(obj_battle_unit) {	
	var _bottom_x = screenToTileXG(x, y, other.tile_size, other.init_x, other.init_y) - 1;
	var _bottom_y = screenToTileYG(x, y, other.tile_size, other.init_x, other.init_y) - 1;

	depth = -(tileToScreenYG(_bottom_x, _bottom_y, other.tile_size, other.init_y));
}

state();
