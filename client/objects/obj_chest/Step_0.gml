/// @description
if (gui_open) {
	if(!instance_exists(obj_chest_inventory)) {
		var _chest = self;
		instance_create_depth(0, 0, 0, obj_chest_inventory, {
			chest: _chest
		});
	}
} else {
	instance_destroy(obj_chest_inventory);	
}

