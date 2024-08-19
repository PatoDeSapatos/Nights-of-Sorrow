enum dungeon_types {
	DEFAULT,
	COUNT
}

function get_dungeon_type_table(_type, _level) {
	var _default_table = {
		rooms_amount: round(3.5 * _level),
		chest_spawn: 20 + (0.5 * _level)
		/*spawnables: [
			["mercador", 0.5]
		]*/
	}

	switch(_type) {
		
	}

	return _default_table
}