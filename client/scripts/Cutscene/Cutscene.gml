function action_end() {
	with(obj_cutscene) {
		action++;
		timer = 0;
		image = 0;
		if (action >= array_length(cutscene)) {
			if (instance_exists(obj_battle_manager)) obj_battle_manager.animating = false;
			instance_destroy();
		}
	}
}

/// @param id
/// @param x
/// @param y
/// @param relative_to_character
/// @param speed
function cutscene_move_character(_id, _x, _y, _relative, _spd) {
	if ( x_dest == noone ) {
		if (_relative) {
			x_dest = _id.x + _x;	
			y_dest = _id.y + _y;
		} else {
			x_dest = _x;
			y_dest = _y;
		}
	}
	
	var _xx = x_dest;
	var _yy = y_dest;
	
	with (_id) {
		if (point_distance(x, y, _xx, _yy) >= _spd) {	
			var _dir = point_direction(x, y, _xx, _yy);	
			var hspd = lengthdir_x(_spd, _dir);
			var vspd = lengthdir_y(_spd, _dir);
		
			x += hspd;
			y += vspd;
			
			var _angle = point_direction(x, y, _xx, _yy);

			if (_angle >= 25 && _angle <= 185) {
				facing_up = true;
			} else {
				facing_up = false;
			}
			
			if (_angle >= 85 && _angle <= 275) {
				facing_right = -1;	
			} else {
				facing_right = 1;	
			}
			
		} else {
			x = _xx;
			y = _yy;
			other.x_dest = noone;
			other.y_dest = noone;
			
			if (other.action+1 >= array_length(other.cutscene)) {
				facing_right = 1;
				facing_up = false;
			}
			
			action_end();
		}	
	}
}