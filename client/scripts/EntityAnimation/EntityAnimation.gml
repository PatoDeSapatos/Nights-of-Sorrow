function Sprite(_sprite, _image) constructor {
	sprite = _sprite;
	image = _image;
}

function SpriteSet(_hair, _head, _hand, _hat, _clothing) constructor {
	hair = new Sprite(spr_hair, _hair);
	head = new Sprite(spr_head_acessories, _head);
	hand = new Sprite(spr_hand_acessories, _hand);
	hat = new Sprite(spr_hats, _hat);
	clothing = _clothing;
}