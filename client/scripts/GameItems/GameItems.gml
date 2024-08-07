enum ItemCategory {
	DEFAULT,
	MATERIAL,
	WEAPON,
	LENGTH	
}

// Slots
#macro Hand1Slot "hand1"
#macro Hand2Slot "hand2"
#macro bothHandsSlot "bothHands"

function Item(_name, _display_name, _sprId, _category, _max_stack) constructor {
	name = _name;
	display_name = _display_name;
	sprId = _sprId;
	max_stack = _max_stack;
	category = _category;
}

function Material_Item(_name, _display_name, _sprId, _category, _max_stack) : Item(_name, _display_name, _sprId, _category, _max_stack) constructor {}

function Equipment_Item(_name, _display_name, _sprId, _category, _status, _slot, _max_stack ) : Item(_name, _display_name, _sprId, _category, _max_stack) constructor {
	slot = _slot;
	status = _status;
}

function Consumable_Item(_name, _display_name, _sprId, _category, _effect, _max_stack) : Item() constructor {
	effect = _effect;	
}

function Status(_hp = 0, _defense = 0, _magic_defense = 0, _attack = 0, _magic_attack = 0, _spd = 0, _luck = 0) constructor {
	hp = _hp;
	defense = _defense;
	magic_defense = _magic_defense;
	attack = _attack;
	magic_attack = _magic_attack;
	spd = _spd;
	luck = _luck;
}

function add_material_item( _name, _display_name, _sprId, _category, _max_stack = 999 ) {
	struct_set( global.items, struct_names_count(global.items), new Material_Item(_name, _display_name, _sprId, _category, _max_stack) );
}

function add_equipment_item( _name, _display_name, _sprId, _category, _status, _slot, _max_stack = 999 ) {
	struct_set( global.items, struct_names_count(global.items), new Equipment_Item(_name, _display_name, _sprId, _category, _status, _slot, _max_stack) );
}

function add_consumable_item( _name, _display_name, _sprId, _category, _effect, _max_stack = 999 ) {
	struct_set( global.items, struct_names_count(global.items), new Consumable_Item(_name, _display_name, _sprId, _category, _effect, _max_stack) );
}

function init_items() {
	// Without Status
	add_material_item( "SLIME_BALL", "Bola de Slime", 0, ItemCategory.MATERIAL, 20 );
	add_material_item( "BONE", "Osso", 1, ItemCategory.MATERIAL );
	
	// With Status
	add_equipment_item( "MAD_HAMMER", "Martelo Maluco", 2, ItemCategory.WEAPON, new Status(0, 0, 0, 5, 0, 0), bothHandsSlot, 1 );
	add_equipment_item( "STICKY_HAMMER", "Martelo Grudento", 3, ItemCategory.WEAPON, new Status(0, 0, 0, 10, 0, 0), Hand1Slot, 1 );
}