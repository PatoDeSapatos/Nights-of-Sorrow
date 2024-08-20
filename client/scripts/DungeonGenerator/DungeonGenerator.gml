function generate_dungeon(_dungeon_type = -1, _level = 1) {
	var roomSize = obj_dungeon_manager.roomSize
	
	if (_dungeon_type == -1) {
		_dungeon_type = irandom(dungeon_types.COUNT - 1)
	}
	
	var _dungeon_type_table = get_dungeon_type_table(_dungeon_type, _level)
    var ambient = {
		dungeon_type_table: _dungeon_type_table,
        roomsAmount: _dungeon_type_table.rooms_amount,
		offsets: [
	        new Point(0, -1), //top
	        new Point(0, 1), //bottom
	        new Point(1, 0), //right
	        new Point(-1, 0), //left
	    ],
        offsetLetter: [
            "U",
            "D",
            "R",
            "L"
        ],
		toCollapse: [],
        nodes: [],
        emptyNode: new Node(""),
        salas: 1,
        nodeGrid: [],
        roomsWidth: obj_dungeon_manager.width div roomSize,
        roomsHeight: obj_dungeon_manager.height div roomSize,
		initX: -1,
		initY: -1,
		endX: -1,
		endY: -1
	}

    for (var i = 0; i < ambient.roomsHeight; i++) {
        ambient.nodeGrid[i] = []
        for (var j = 0; j < ambient.roomsWidth; j++) {
            ambient.nodeGrid[i][j] = noone
        }
    }

    method(ambient, register)()
	var data = date_current_datetime()
    method(ambient, collapse)()
    show_debug_message(string("finished in: {0} s with {1} rooms", date_second_span(data, date_current_datetime()), ambient.salas))

	method(ambient, generate_init_pos)()
	method(ambient, generate_end_pos)()
	//for each spawnable...

    return ambient
}

function collapse() {
	array_push(toCollapse, new Point(roomsWidth / 2, roomsHeight / 2))
	var initial = true
	
	while (array_length(toCollapse) > 0) {
		var atual = array_shift(toCollapse)
		if (is_struct(nodeGrid[atual.y][atual.x])) continue

		var potentialNodes = []
		array_copy(potentialNodes, 0, nodes, 0, array_length(nodes))

        var nome = []
        var nomeRestritivo = []
		
		for (var i = 0; i < array_length(offsets); i++) {
            
            var neighbour = new Point(atual.x + offsets[i].x, atual.y + offsets[i].y)

            if (isInside(neighbour)) {
                var neighbourNode = nodeGrid[neighbour.y][neighbour.x]

                if (is_struct(neighbourNode)) {
                    if (neighbourNode == emptyNode) addRestritivo(i, nomeRestritivo)
                    switch (i) {
                        case 0:
                            if (string_pos("D", neighbourNode.name)) array_push(nome, "U")
                            else addRestritivo(i, nomeRestritivo)
                            break
                        case 1:
                            if (string_pos("U", neighbourNode.name)) array_push(nome, "D")
                            else addRestritivo(i, nomeRestritivo)
                            break
                        case 2:
                            if (string_pos("L", neighbourNode.name)) array_push(nome, "R")
                            else addRestritivo(i, nomeRestritivo)
                            break
                        case 3:
                            if (string_pos("R", neighbourNode.name)) array_push(nome, "L")
                            else addRestritivo(i, nomeRestritivo)
                            break
                    }
                } else if (!array_contains(toCollapse, neighbour)) {
                    array_push(toCollapse, neighbour)
                }
            } else {
                addRestritivo(i, nomeRestritivo)
            }
        }
		
		apenasCompativeis(potentialNodes, nome, nomeRestritivo)
		
		if (array_length(potentialNodes) <= 0) {

            if (initial) {
                var init_node = nodes[irandom(array_length(nodes) - 1)]
                nodeGrid[atual.y][atual.x] = init_node
				salas += string_length(init_node.name)
                initial = false
            } else {
                nodeGrid[atual.y][atual.x] = emptyNode
            }
        } else {
            var randomNode

            if (salas < roomsAmount) {
                array_sort(potentialNodes, function(a, b) { return string_length(b.name) - string_length(a.name) })
                randomNode = irandom(floor(array_length(potentialNodes) / 2))
            } else {
                array_sort(potentialNodes, function(a, b) { return string_length(a.name) - string_length(b.name) })
                randomNode = 0
            }

			var new_node = potentialNodes[randomNode]
            salas += string_length(new_node.name) - 1
            nodeGrid[atual.y][atual.x] = new_node
        }
	}
}

function apenasCompativeis(potenciais, nome, nomeRestritivo) {
    if (array_length(nome) == 0) return array_delete(potenciais, 0, array_length(potenciais))

    for (var i = array_length(potenciais) - 1; i >= 0; --i) {
        
		var ambient = {
			potenciais: potenciais,
			i: i
		}
		
        var includes = array_all(nome, method(ambient, function(v) { return string_pos(v, potenciais[i].name) != 0 }))
		var excludes = array_any(nomeRestritivo, method(ambient, function(v) { return string_pos(v, potenciais[i].name) != 0 }))

        if (!includes || excludes) {
            array_delete(potenciais, i, 1)
        }
    }
}

function isInside(_point) {
    if (_point.x >= 0 && _point.x < roomsWidth && _point.y >= 0 && _point.y < roomsHeight) {
        return true
    }
    return false
}

function addRestritivo(i, nomeRestritivo) {
    array_push(nomeRestritivo, offsetLetter[i])
}

function register() {
	if (!directory_exists(working_directory + "\\dungeon_rooms")) {
		return;
	}
	
	var _room_name = file_find_first(working_directory + "\\dungeon_rooms\\generated\\*.png", 0);
	while(_room_name != "") {

		array_push(nodes, new Node(_room_name))
		_room_name = file_find_next();
	}
}

function spawn_rooms(_name_length = -1, exclude_marked = true) {
	var _ner_array = []
	for (var _y = 0; _y < array_length(nodeGrid); ++_y) {
	    for (var _x = 0; _x < array_length(nodeGrid[_y]); ++_x) {

			var _node = nodeGrid[_y][_x]

			if (_node.name == "" || !array_contains(_node.args, "s")) continue
			if (exclude_marked && _node.spawn != -1) continue
			if (_name_length != -1) {
				if (string_length(_node.name) != _name_length) continue
			}

		    array_push(_ner_array, {
				x: _x,
				y: _y
			})
		}
	}
	return _ner_array
}

function generate_init_pos() {
	var roomSize = obj_dungeon_manager.roomSize
	var _sprm_array = spawn_rooms()
	var _room = _sprm_array[irandom(array_length(_sprm_array) - 1)]
	
	nodeGrid[_room.y][_room.x].spawn = spawns.INITIAL

	var _initX = ((_room.x * roomSize) + (roomSize div 2))
	var _initY = ((_room.y * roomSize) + (roomSize div 2))

	initX = tileToScreenX(_initX, _initY)
	initY = tileToScreenY(_initX, _initY)
}

function generate_end_pos() {
	var roomSize = obj_dungeon_manager.roomSize
	var _sprm_array = spawn_rooms(1)
	var _room = _sprm_array[irandom(array_length(_sprm_array) - 1)]

	var _endX = ((_room.x * roomSize) + (roomSize div 2))
	var _endY = ((_room.y * roomSize) + (roomSize div 2))

	endX = tileToScreenX(_endX, _endY)
	endY = tileToScreenY(_endX, _endY)
}

function Node(_fileName) constructor {
    fileName = _fileName
	name = ""
	args = []
	spawn = -1

	if (fileName != "") {
		var _args = string_split(string_split(_fileName, ".")[0], "_")
		name = string_upper(_args[2])
		array_copy(args, 0, _args, 3, array_length(_args))
	}
}

function Point(_x, _y) constructor {
    x = round(_x)
    y = round(_y)
}