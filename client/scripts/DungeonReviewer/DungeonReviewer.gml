function review_dungeon() {
	var ambient = {
		map,
		nodeGrid: map.nodeGrid,
		roomSize,
	}
	
	method(ambient, assure)()
	method(ambient, generate_init_pos)()
	method(ambient, generate_end_pos)()
	method(ambient, spawn_spawnables)()
}

function assure() {
	var _spawn_rooms_length = array_length(spawn_rooms(, false))
	var _spawnables_length = array_length(map.dungeon_type_table.spawnables)
	
	if (_spawn_rooms_length < _spawnables_length) {
		var _nodes = get_nodes(["s"])
		
		for (var i = 0; i < _spawn_rooms_length - _spawnables_length; ++i) {
		    var _old_node = _nodes[irandom(array_length(_nodes) - 1)]
			var _new_nodes_array = find_nodes(string_length(_old_node.node.name), _old_node.node.args)
			var _new_node = _new_nodes_array[irandom(array_length(_new_nodes_array) - 1)]

			nodeGrid[_old_node.y][_old_node.x] = _new_node
		}
	}
}

function generate_init_pos() {
	var _sprm_array = spawn_rooms()
	var _room = _sprm_array[irandom(array_length(_sprm_array) - 1)]
	
	nodeGrid[_room.y][_room.x].spawn = spawns.INITIAL

	var _initX = ((_room.x * roomSize) + (roomSize div 2))
	var _initY = ((_room.y * roomSize) + (roomSize div 2))

	map.initX = tileToScreenX(_initX, _initY)
	map.initY = tileToScreenY(_initX, _initY)
}

function generate_end_pos() {
	var _sprm_array = spawn_rooms(1)
	var _room = _sprm_array[irandom(array_length(_sprm_array) - 1)]

	nodeGrid[_room.y][_room.x].spawn = spawns.END
}

function spawn_spawnables() {
	var _spawnables = map.dungeon_type_table.spawnables
	
	for (var i = 0; i < array_length(_spawnables); ++i) {
		var _spwnbl = _spawnables[i]

		if (irandom(99) < _spwnbl[1]) {
			var _sprm_array = spawn_rooms()
			var _room = _sprm_array[irandom(array_length(_sprm_array) - 1)]
	
			nodeGrid[_room.y][_room.x].spawn = _spwnbl[0]
		}
	}
}

function spawn_rooms(_name_length = -1, exclude_marked = true) {
	var _array = []
	for (var _y = 0; _y < array_length(nodeGrid); ++_y) {
	    for (var _x = 0; _x < array_length(nodeGrid[_y]); ++_x) {

			var _node = nodeGrid[_y][_x]

			if (_node.name == "" || !array_contains(_node.args, "s")) continue
			if (exclude_marked && _node.spawn != -1) continue
			if (_name_length != -1) {
				if (string_length(_node.name) != _name_length) continue
			}

		    array_push(_array, {
				x: _x,
				y: _y
			})
		}
	}
	return _array
}

function get_nodes(args_array) {
	var _array = []
	for (var _y = 0; _y < array_length(nodeGrid); ++_y) {
	    for (var _x = 0; _x < array_length(nodeGrid[_y]); ++_x) {

			var _node = nodeGrid[_y][_x]

			if (_node.name == "") continue
			if (is_array(args_array)) {
				var valid = true
				for (var ii = 0; ii < array_length(args_array); ++ii) {
					if (!array_contains(_node.args, args_array[ii])) {
						valid = false
						break
					}
				}
				if (!valid) continue
			}

		    array_push(_array, {
				node: _node,
				x: x,
				y: y
			})
		}
	}
	return _array
}

function find_nodes(_name_length, args_array) {
	var _array = []

	for (var i = 0; i < array_length(map.nodes); ++i) {
	    var _node = map.nodes[i]
		
		if (string_length(_node.name) != _name_length) continue
		
		var valid = true
		for (var ii = 0; ii < array_length(args_array); ++ii) {
			if (!array_contains(_node.args, args_array[ii])) {
				valid = false
				break
			}
		}
		if (!valid) continue
		
		array_push(_array, _node)
	}
	return _array
}