function decode_tile_entity_id(_id) {
	var _splitted = string_split(_id, "|")
	var level = _splitted[0]
	var _x = _splitted[1]
	var _y = _splitted[2]

	return {
		level,
		x: _x,
		y: _y
	}
}