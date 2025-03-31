function PropInfo(_sprite, _image, _coll, _hp, _func) constructor {
	sprite = _sprite;
	image = _image;
	coll = _coll;
	func = _func;
	
	unit = {
		stats: new Stats(_hp),
		hp: _hp,
		position: {
			x: -1,
			y: -1
		},
	}
}

function battle_create_props(_prop_info, _position) {
	with(obj_battle_manager) {
		var _prop = instance_create_depth(
			tileToScreenXExt(_position.x, _position.y, tile_size, init_x),
			tileToScreenYExt(_position.x, _position.y, tile_size, init_y),
			-1,
			obj_battle_prop
		);

		_prop_info.unit.position = {
			x: _position.x,
			y: _position.y
		};
		_prop.prop_info = _prop_info;
		 
		array_push(props, _prop);
	}
}