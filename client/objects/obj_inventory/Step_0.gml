/// @description
if ( keyboard_check_pressed( ord("E") ) ) {
	inventory_open = !inventory_open;	
}

if (keyboard_check(ord("M"))) {
	inventory_add_item(inventory, 0, 10);	
}

if ( keyboard_check(ord("N")) ) {
	inventory_remove_item(inventory, 0, 10);	
}