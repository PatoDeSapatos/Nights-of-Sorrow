event_inherited()

slots = 15
item_spawn = (global.server.level * 2) + 30

interaction = function() {
	if (!data) {
		global.server.send_websocket_message("GET_TILE_ENTITY", {
			invite: global.server.dungeon_code,
			tileEntId: uid
		})
	} else {
		show_gui()
	}
}

coll_interaction = interaction;

gen_data = function() {
	data = {
		inventory: []
	}
	
	for (var i = 0; i < slots; ++i) {
	    if (irandom(99) < item_spawn) {
			array_push(data.inventory, struct_get(global.items, irandom(struct_names_count(global.items))))
		}
	}
}

set_data = function(_data) {
	data = _data
	show_gui()
}

show_gui = function() {
	show_debug_message(data)
}