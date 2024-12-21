function action_end() {
	with(obj_cutscene) {
		action++;
		timer = 0;
		image = 0;
		setup = false;
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

function cutscene_use_action(_user, _action, _targets) {
	if (!setup && !is_undefined(_action.userAnimation) && !is_undefined( _user.unit.sprites[$ _action.userAnimation] ) ) {
		image = _user.sprite_index;
		_user.sprite_index = _user.unit.sprites[$ _action[$ "userAnimation"]];
		_user.image_index = 0;
		setup = true;
	}
	
	var _frames = (_user.object_index == obj_party_unit) ? _user.idle_frames-1 : sprite_get_number(_user.sprite_index)-1;
	
	if (_user.image_index >= _frames) {
		if (!is_undefined(_action.hit_effect)) {
			for (var i = 0; i < array_length(_targets); ++i) {
			    var _target = _targets[i];
				var _effect = instance_create_depth(_target.x, _target.y, _target.depth-1, obj_battle_effect);
				_effect.sprite_index = _action.hit_effect;
			}
		}

		_action.func(_user, _targets);
		_user.sprite_index = image;
		_user.image_index = 0;
		action_end();
	}
}

function cutscene_animate_once(_id, _sprite_index) {
	if (!setup) {
		image = _id.sprite_index;
		_id.sprite_index = _sprite_index;
		_id.image_index = 0;
		setup = true;
	}
	
	if (_id.image_index >= sprite_get_number(_sprite_index)-1) {
		_id.sprite_index = image;
		action_end();
	}
	
}