/// @description
draw_set_color(c_white);
draw_rectangle( 
	items_box_x,
	items_box_y,
	items_box_x + items_box_w,
	items_box_y + items_box_h,
	false
);

draw_set_color(c_black);

for (var i = 0; i < array_length(inventory); ++i) {
	var _item = get_item_by_id( inventory[i].id );
	var _quantity = inventory[i].quantity;
	
    draw_text( items_box_name_x, items_box_name_y, _item.name );
	draw_text( items_box_quantity_x, items_box_name_y, _quantity );
}

draw_set_color(c_white);
