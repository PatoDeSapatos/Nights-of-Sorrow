function inventory_draw_skills() {
	if ( !surface_exists(items_box_list_surf) ) {
		items_box_list_surf = surface_create(items_box_w, items_box_h);	
	}
	surface_set_target(items_box_list_surf);
	draw_clear_alpha(c_black, 0);
	
	var _fnt = draw_get_font();
	draw_set_font(fnt_inventory)
	draw_set_valign(fa_middle);
	
	var _current_y = items_box_name_offset;
	var _prev_selected_item = selected_item;
	for (var i = 0; i < array_length(skills); ++i) {
		var _y = _current_y + items_box_name_h/2 + items_box_border/2;
		var _item = skills[i];
	
		var _mouse_hover = mouse_navigation && point_in_rectangle(mouse_gui_x, mouse_gui_y, items_box_x, items_box_name_y + _y - items_box_name_h/2, items_box_x + items_box_w, items_box_name_y + _y + items_box_name_h/2);
	
		if (_mouse_hover) {
			selected_item = i;
		}
	
	
		var _col = get_type_color(skills[i].types[0]);
		var _alpha = selected_item == i ? 1 : .7;
	
		if ( selected_item == i ) {
		}
		
		draw_set_alpha(_alpha);
		draw_set_color(_col);
		draw_rectangle(0, _y - items_box_name_h/2 - items_box_border/4 + 1, items_box_w, _y + items_box_name_h/2 + items_box_border/4 - 1, false);
		draw_set_color(c_white);
		draw_set_alpha(1);
	
		if (skills[i] == active_item) {
			active_item_y = _y + items_box_name_y - items_box_name_h/2;	
		}
	
		// Item Image
		var _type = (struct_exists(_item, "types")) ? (_item.types[0]) : (0);
		draw_sprite_ext( spr_move_type_icons, _type, items_box_name_x - items_box_spr_size, _y, global.res_scale * 2, global.res_scale * 2, 0, c_white, 1 );
	
		// Item Name
		draw_set_color(c_white);
		draw_set_halign(fa_left);
		draw_text( items_box_name_x, _y, _item.name );
	
		// Item Category
		draw_sprite_ext( spr_move_category_icons, _item.moveCategory, items_box_category_x, _y, global.res_scale * 2, global.res_scale * 2, 0, c_white, 1 );
	
		_current_y += items_box_name_h + items_box_border/2;
	}
	
	surface_reset_target();
	draw_surface(items_box_list_surf, items_box_x, items_box_name_y);
	
	
	// Skill desc
	if (!is_struct(skills[selected_item])) return;
	
	var _item = skills[selected_item];
	
	draw_set_color(c_black);
	draw_set_alpha(.8);
	draw_rectangle(equipment_box_x, equipment_box_y, equipment_box_x + equipment_box_w, equipment_box_y + equipment_box_h, false);
	draw_set_color(c_white);
	draw_set_alpha(1);
	draw_sprite_stretched(spr_inventory_bg, 0, equipment_box_x, equipment_box_y, equipment_box_w + global.res_scale, equipment_box_h);
	
	draw_set_halign(fa_center);
	draw_set_valign(fa_top);
	draw_text(equipment_box_x + equipment_box_w/2, equipment_box_y + equipment_box_border, _item.name)
	
	draw_set_font(_fnt);
	draw_set_halign(fa_left)
	draw_set_valign(fa_top);
}