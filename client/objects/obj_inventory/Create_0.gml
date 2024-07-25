/// @description
enum TABS {
	ITEMS,
	CRAFTING,
	HABILITYS,
	LENGTH
}

inventory_open = true;
inventory_size = 64;

// Menu Parameters
gui_w = display_get_gui_width();
gui_h = display_get_gui_height();
border = gui_w div 8;

// Items box
items_box_w = gui_w/2.5;
items_box_h = gui_h;
items_box_x = gui_w - border - items_box_w;
items_box_y = 0;
items_box_border = items_box_w div 10;

items_box_spr_size = sprite_get_height(spr_items) * (global.res_scale * 2) + 5;

items_box_category_y = 0; 
items_box_category_h = sprite_get_height(spr_items_categories) * (global.res_scale*2.5) + 5;

items_box_title_y = items_box_y + items_box_category_y + items_box_category_h + items_box_border/2;
items_box_title_h = sprite_get_height(spr_items) * global.res_scale*2 + 10;

items_box_name_x = items_box_border + items_box_spr_size;
items_box_name_y = items_box_title_y + items_box_title_h;
items_box_name_offset = 0;

items_box_name_w = (items_box_w div 2) - items_box_border*2;
items_box_name_h = sprite_get_height(spr_items) * (global.res_scale * 2) + 5;
//items_box_name_h = (items_box_h - items_box_title_h - items_box_border)/12;

items_box_category_x = items_box_w - items_box_border;
items_box_quantity_x = items_box_category_x - items_box_spr_size - items_box_border;

items_box_list_surf = -1;

// Navigation
selected_item = 0;
selected_category = 0;
selected_tab = 0;
mouse_navigation = false;
focus = 0;

// Inventory Tabs
tabs_y = [];
var _current_tab_y = items_box_title_y + items_box_title_h + items_box_border/4;;
var _tab_h = sprite_get_height(spr_inventory_tabs);
for (var i = 0; i < sprite_get_number(spr_inventory_tabs); ++i) {
    tabs_y[i] = _current_tab_y;
	_current_tab_y += (_tab_h - 3) * global.res_scale*2;
}

// Ingredients
ingredients_box_x = items_box_x;
ingredients_box_y = gui_h - items_box_h/2.8;
ingredients_box_w = items_box_w;
ingredients_box_h = gui_h - ingredients_box_y;

ingredients_cols = 2;
ingredients_border = 20 * global.res_scale;

ingredient_scale = 1.5 * global.res_scale;
ingredient_w = (ingredients_box_w - ingredients_border*2) / 2;
ingredient_h = sprite_get_height(spr_items) * ingredient_scale;

ingredient_spr_w = sprite_get_width(spr_items)*ingredient_scale;

// Inventory
max_items = 10;

// inputs
up_input = 0;
down_input = 0;
left_input = 0;
right_input = 0;

mouse_gui_x = 0;
mouse_gui_y = 0;
mouse_l = 0;
mouse_r = 0;

inventory = [];
recipes = [];
recipe_ingredients = [];
inventory_add_recipe(recipes, 0);
