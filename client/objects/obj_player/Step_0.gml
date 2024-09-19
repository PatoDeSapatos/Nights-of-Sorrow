/// @description Getting player inputs
if ( player_username == global.server.username ) {
	struct_foreach(inputs, function (_key, _value) { 
		var _key_name = struct_get( _value, "key_name" );
		var _keys = struct_get(global.controls, _key_name);
		var _active = false;

		for (var i = 0; i < array_length(_keys); ++i) {
		    _active = _active || keyboard_check(_keys[i]);
		}
	
		struct_set(struct_get(inputs, _key), "value", _active);
	});

	if (!global.pause) {
		up = inputs.input_up.value;
		down = inputs.input_down.value;
		left = inputs.input_left.value;
		right = inputs.input_right.value;

		input_magnitude = (down - up != 0) || (right - left != 0);
		input_direction = point_direction(0, 0, (right - left), (down - up));
	}

	state();
	
	if ( keyboard_check_pressed(ord("G")) ) {
		if (sprites[0].image != -1) sprites[0].image += 2;
		else sprites[0].image++;
		
		if ( sprites[0].image >= sprite_get_number(spr_hair) ) {
			sprites[0].image = -1;	
		}
	}
	
	if ( keyboard_check_pressed(ord("J")) ) {
		if (sprites[1].image != -1) sprites[1].image += 2;
		else sprites[1].image++;
		
		if ( sprites[1].image >= sprite_get_number(spr_head_acessories) ) {
			sprites[1].image = -1;	
		}
	}
	
	if ( keyboard_check_pressed(ord("K")) ) {
		if (sprites[2].image != -1) sprites[2].image += 2;
		else sprites[2].image++;
		
		if ( sprites[2].image >= sprite_get_number(spr_hand_acessories) ) {
			sprites[2].image = -1;	
		}
	}
	
	if ( keyboard_check_pressed(ord("H")) ) {
		if (sprites[array_length(sprites)-1].image != -1) sprites[array_length(sprites)-1].image += 2;
		else sprites[array_length(sprites)-1].image++;

		if ( sprites[array_length(sprites)-1].image >= sprite_get_number(spr_hats) ) {
			sprites[array_length(sprites)-1].image = -1;	
		}
	}
} else {
	if (x == _x && y == _y) return;
	
	var xgap = (_x - x)
	var ygap = (_y - y)

	if (abs(xgap) < 0.05) {
		x = _x
	} else {
		x += min(spd, xgap / 3)
	}

	if (abs(ygap) < 0.05) {
		y = _y
	} else {
		y += min(spd, ygap / 3)
	}
}