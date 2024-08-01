enum dungeon_types {
	DEFAULT,
	COUNT
}

function get_dungeon_type_table(_type) {
	var _default_table = {
		rooms_amount: 30,
		chest_spawn: 50
	}

	switch(_type) {
		case dungeon_types.DEFAULT:
			return _default_table
	}
}