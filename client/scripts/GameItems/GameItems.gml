enum ItemCategory {
	DEFAULT,
	MATERIAL,
	WEAPON,
	LENGTH	
}

function Item(_name, _sprId, _category, _status, _max_stack) constructor {
	name = _name;
	sprId = _sprId;
	max_stack = _max_stack;
	category = _category;
	status = _status;
}

function Status(_hp, _defense, _magic_defense, _attack, _magic_attack, _spd) constructor {
	hp = _hp;
	defense = _defense;
	magic_defense = _magic_defense;
	attack = _attack;
	magic_attack = _magic_attack;
	spd = _spd;
}

function add_item( _name, _sprId, _category, _status = -1, _max_stack = 999 ) {
	ds_map_add( global.items, ds_map_size(global.items), new Item(_name, _sprId, _category, _status, _max_stack) );
}

function init_items() {
	// Without Status
	add_item( "Bola de Slime", 0, ItemCategory.MATERIAL, -1, 20 );
	add_item( "Osso", 1, ItemCategory.MATERIAL );
	
	// With Status
	add_item( "Martelo Maluco", 2, ItemCategory.WEAPON, new Status(0, 0, 0, 5, 0, 0), 1 );
}