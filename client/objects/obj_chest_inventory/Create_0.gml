/// @description
event_inherited();

inventory_open = true;
items_box_x = border;
has_equipment_box = false;
has_tabs = false;
item_option_x = items_box_x + items_box_border*1.5;

// chest needs to be passed when this object is created
inventory = chest.data.inventory;

//Add the options to transfer items
var _categories = struct_get_names(bag_item_options);
var _options_names = ["Transfer One", "Transfer All", "Cancel"];

var _action_func = function(_selected_option) {
	switch(_selected_option) {
		case 0:
			inventory_transfer_item(inventory, global.player_inventory.inventory, active_item.id, 1);
			if (get_item_quantity_in_inventory(inventory, active_item.id) <= 0) {
				focus = FOCUS.LIST;
			}
			break;
		case 1:
			inventory_transfer_item(inventory, global.player_inventory.inventory, active_item.id, get_item_quantity_in_inventory(inventory, active_item.id));
			focus = FOCUS.LIST;
			break;
		case 2:
			focus = FOCUS.LIST;
			break;
	}
}

for (var i = 0; i < struct_names_count(bag_item_options); ++i) {
    struct_set( struct_get(bag_item_options, _categories[i]), "options", _options_names );
	struct_set( struct_get(bag_item_options, _categories[i]), "action", new Item_Action( _action_func ) );
}