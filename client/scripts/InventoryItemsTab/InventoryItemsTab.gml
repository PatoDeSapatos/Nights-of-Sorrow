function inventory_draw_items() {
// Items List
draw_items(inventory, false);

var _changed_category = selected_category;
selected_category += right_input - left_input;
selected_category = clamp(selected_category, 0, ItemCategory.LENGTH - 1);
if ( _changed_category != selected_category ) {
	selected_item = 0;	
}	
}