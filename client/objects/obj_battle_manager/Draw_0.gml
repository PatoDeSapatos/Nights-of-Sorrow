/// @description
var _mouse_tile_x = screenToTileXG(mouse_x, mouse_y, tile_size, init_x, init_y);
var _mouse_tile_y = screenToTileYG(mouse_x, mouse_y, tile_size, init_x, init_y);

mouse_hover.x = -1;
mouse_hover.y = -1;

for (var _y = 0; _y < array_length(grid); ++_y) {
    for (var _x = 0; _x < array_length(grid[0]); ++_x) {
		var _xx = tileToScreenXG(_x, _y, tile_size, init_x);
		var _yy = tileToScreenYG(_x, _y, tile_size, init_y);
		var _in_path = false;
		var _in_mov_range = false;
		
		if (_mouse_tile_x == _x && _mouse_tile_y == _y) {
			mouse_hover.x = _x;
			mouse_hover.y = _y;
		}
		
		if (state == battle_state_turn && player_turn && movement_actions > 0 && array_length(targeted_tiles) > 0) {
			for (var k = 0; k < array_length(targeted_tiles); ++k) {
			    if ( targeted_tiles[k, 0] == _x && targeted_tiles[k, 1] == _y) {
					_in_mov_range = true;
					break;
				}
			}
		}

		if (cursor_in_range && unit_hover == noone && array_length(path) > 0) {
			for (var k = 0; k < array_length(path); ++k) {
			    if ( path[k, 0] == _x && path[k, 1] == _y) {
					_in_path = true;
					break;
				}
			}
		}
				
		if (cursor_in_range && _in_path) {
			draw_sprite_ext(spr_dungeon_tileset, 5, _xx, _yy, scale, scale, 0, c_white, 1);
		} else draw_sprite_ext(spr_dungeon_tileset, grid[_y][_x].spr, _xx, _yy, scale, scale, 0, c_white, 1);
	    

		if (_in_mov_range) {
			draw_sprite_ext(spr_dungeon_tileset, 2, _xx, _yy, scale, scale, 0, c_white, .75);
		}
	}
}

if (mouse_hover.x == -1 || mouse_hover.y == -1) {
	path = [];	
}