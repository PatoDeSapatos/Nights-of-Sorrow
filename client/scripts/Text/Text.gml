function draw_desc_center(_start_x, _start_y, _text, _width, _sep) {
	var _halign = draw_get_halign();
	var _valign = draw_get_valign();
	
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	
	var _curr_x = _start_x;
	var _curr_y = _start_y - _sep;
	
	var array = string_split(_text, " ");	
	
	for (var i = 0; i < array_length(array); ++i) {
	    var _word = string("{0} ", array[i]);
		var _word_w = string_width(_word);
		
		if (i == 0 || _curr_x + _word_w >= _start_x + _width) {
			_curr_y += _sep;
			
			var _line_w = 0;
			for (var j = i; j < array_length(array); ++j) {
				if (_line_w + string_width(array[j] + " ") > _width) {
					break;	
				}
				
				_line_w += string_width(array[j] + " ");
			}
			_curr_x = _start_x + (_width - _line_w + string_width(" "))/2;
		}
		
		var _col = get_word_highlight(_word);
		draw_text_color(_curr_x, _curr_y, _word, _col, _col, _col, _col, 1);
		_curr_x += _word_w;
	}
	
	draw_set_halign(_halign);
	draw_set_valign(_valign);
}

function highlight_word_filter(_char) {
	return string_pos(_char, "abcdefghijklmnopqrstuvwxyzç") > 0;
}

function highlight_word_reduce(_prev, _char) {
	return string_concat(_prev, _char);
}

function get_word_highlight(_word, _default=c_white) {
	var _parsed_word = string_lower(string_trim(_word));
	
	var _array = [];
	for (var i = 1; i <= string_length(_parsed_word); ++i) {
	    array_push(_array, string_char_at(_parsed_word, i));
	}
	
	_array = array_filter(_array, highlight_word_filter);
	
	_parsed_word = array_reduce(_array, highlight_word_reduce, "");
	
	switch(_parsed_word) {
		case "poison":
			return get_type_color(MOVE_TYPES.POISON);
		case "damage":
			return get_type_color(MOVE_TYPES.SLASHING);
		case "heal": case "heals":
			return make_color_rgb(117, 167, 67);
		case "raises": case "raise":
			return make_color_rgb(79, 143, 186);
		
		default:
			return _default;
	}
}