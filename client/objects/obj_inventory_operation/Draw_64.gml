/// @description
draw_set_valign(fa_middle);
draw_set_halign(fa_left);

var _current_y = 10;
for (var i = 0; i < array_length(items); ++i) {
	draw_set_color(items[i, 3]);
    draw_text(10, _current_y, items[i, 2] + ": " + items[i, 0] + " - x" + string(items[i, 1]));
	_current_y += string_height(items[i, 0]);
}

draw_set_color(c_white);