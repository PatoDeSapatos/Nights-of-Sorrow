var camX = screenToTileX(round(global.camera.camera_x), round(global.camera.camera_y))
var camY = screenToTileY(round(global.camera.camera_x), round(global.camera.camera_y))
var camW = screenToTileX(round(global.camera.camera_x) + global.camera.camera_w, round(global.camera.camera_y) + global.camera.camera_h)
var camH = camY + 1 + (camW - camX) div 2
camY -= (camW - camX) div 2

var _min_x = max(0, camX - 1);
var _max_x = min(width, camW + 1);

var _min_y = max(0, camY - 1);
var _max_y = min(height, camH + 1);

for (var _y = _min_y; _y < _max_y; _y++) {
    for (var _x = _min_x; _x < _max_x; _x++) {

		var tile = grid[# _x, _y];
		if (is_undefined(tile)) continue

		var sprite = tile.spr
		if (tile == selected) {
			sprite = 0
		} else if (tile == player_bottom) {
			sprite = 2
		}

		draw_sprite_ext(spr_dungeon_tileset, sprite, tileToScreenX(_x, _y), tileToScreenY(_x, _y) + tile.z, scale, scale, 0, c_white, 1);
		
		for (var i = array_length(tile.stack); i > 0; --i) {
			var _stack = tile.get_stack();
			
			if (object_exists(_stack)) {
				var z = tile.z - (tile_size / 2) * i;
				var _inst_y = tileToScreenY(_x, _y) + z;
				var _inst_x = tileToScreenX(_x, _y);
				
				var _instance = instance_create_depth(_inst_x, _inst_y, -(_inst_y - z/2), _stack);
				
				var _parent = object_get_parent(_stack)
				if ((_parent == par_entity || _parent == par_tile_entity) && is_method(_instance.set_uid)) {
					_instance.set_uid(_x, _y)
				}
				
				array_push(tile.stack_instances, _instance)
			}
		}
	}
}

selected = -1
player_bottom = -1