function collision() {
	var collides = false

	var htile = obj_dungeon_manager.grid[# screenToTileX(x + hspd, y)-1, screenToTileY(x + hspd, y)-1]
	if (!is_undefined(htile)) {
		if (htile.coll) {
			hspd = 0
			collides = true
		}
		htile.collide() //ativar colisão de stacks que não tem colisão também
	}

	var vtile = obj_dungeon_manager.grid[# screenToTileX(x, y + vspd)-1, screenToTileY(x, y + vspd)-1]
	if (!is_undefined(vtile)) {
		if (vtile.coll) {
			vspd = 0
			collides = true
		}
		vtile.collide()
	}
	
	var dtile = obj_dungeon_manager.grid[# screenToTileX(x + hspd, y + vspd)-1, screenToTileY(x + hspd, y + vspd)-1]
	if (!is_undefined(dtile)) {
		if (dtile.coll) {
			hspd = 0
			vspd = 0
			collides = true
		}
		dtile.collide()
	}

	return collides
}

function animate() {
	var _max_frames = idle_frames;
	var _init_frame = (facing_up) * _max_frames;
	var _final_frame = _init_frame + _max_frames;
	
	current_image += animation_spd / 60;
	if ( current_image >= _final_frame || current_image < _init_frame ) {
		current_image = _init_frame;	
	}

	image_index = current_image;
}