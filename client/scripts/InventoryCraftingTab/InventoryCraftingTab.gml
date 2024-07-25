
function inventory_draw_recipes() {
	draw_items(recipes, true);
	
	// Ingredients Box
	draw_set_color(c_red);
	draw_rectangle(items_box_x, gui_h - items_box_h/2.8, items_box_x + items_box_w, gui_h, false);
}