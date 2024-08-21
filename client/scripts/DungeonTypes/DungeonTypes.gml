enum dungeon_types {
	DEFAULT,
	COUNT
}

function get_dungeon_type_table(_type, _level) {
	var spawnables = [
		[spawns.MERCADOR, 0.5]
	]
	var _default_table = {
		chest_spawn: 20 + (0.5 * _level),
		rooms_amount: max(10, round(3.5 * _level) + array_length(spawnables)),
		spawnables
	}

	/*switch(_type) {
		case dungeon_types.:
	}*/

	return _default_table
}

enum spawns {
	INITIAL,
	END,
	MERCADOR
}