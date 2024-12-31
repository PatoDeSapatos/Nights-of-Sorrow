/// @description

// Pre set variables
// unit = new Battle_Unit();
// scale = 1;

image_xscale = scale;
image_yscale = scale;

sprites = unit.sprites
idle_frames = 4;
current_image = 0;
animation_spd = 5;

head_sprites = [spr_hair, spr_head_acessories, spr_hats];
facing_right = 1;
facing_up = false;
clothing = 0;

is_broken = false;
is_dead = false;
in_target = false;
animating = false;

ready = false;
charging_turns = 0;
charging_action = noone;
charging_targets = noone;
focusing = false;

z = obj_battle_manager.tile_size/4;