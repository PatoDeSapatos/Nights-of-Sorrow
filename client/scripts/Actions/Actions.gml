global.actions = {
	attack: {
		name: "attack",
		description: "a melee attack!",
		userAnimation: "attack",
		targetRequired: true,
		func: function(_user, _targets) {
			var _damage = ceil(_user.attack + random_range(-_user.attack * .25, _user.attack * .25));
			with(_targets[0]) hp = max(0, hp - _damage);
		}	
	}
	
}