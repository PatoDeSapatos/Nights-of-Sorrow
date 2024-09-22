event_inherited()
image_index = 8

slots = 15
item_spawn = (global.server.level * 2) + 30
gui_open = false

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
		inventory: array_create(15)
	}
	
	for (var i = 0; i < slots; ++i) {
	    if (irandom(99) < item_spawn) {
			data.inventory[i] = struct_get(global.items, irandom(struct_names_count(global.items)))
		}
	}
}

set_data = function(_data) {
	data = _data
	show_gui()
}

show_gui = function() {
	//if (gui_open) return;
	show_debug_message(data)
	gui_open = true
}