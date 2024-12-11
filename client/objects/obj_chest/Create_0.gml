event_inherited()
image_index = 8

slots = 15
item_spawn = (global.server.level * 2) + 30
gui_open = false
inventory = []

interaction = function() {
	if (!data) {
		global.server.send_websocket_message("GET_TILE_ENTITY", {
			invite: global.server.dungeon_code,
			tileEntId: uid
		})
	} else {
		show_gui()
	}
	
	gui_open = !gui_open;	
	global.player_inventory.inventory_open = !global.player_inventory.inventory_open;

}

coll_interaction = interaction;

gen_data = function() {
	data = {
		inventory: inventory
	}
	
	for (var i = 0; i < slots; ++i) {
	    if (irandom(99) < item_spawn) {
			var _quantity = irandom_range(1, 2);
			var _item_id = irandom(struct_names_count(global.items)-1);
			
			var _max_stack = get_item_by_id(_item_id).max_stack;
			if (_quantity > _max_stack) _quantity = _max_stack;
			
			inventory_add_item(data.inventory, _item_id, _quantity);
		}
	}
}

set_data = function(_data) {
	data = _data
	show_gui()
}

show_gui = function() {
	if (gui_open) return;
	show_debug_message(data)
	gui_open = true
}

gen_data();