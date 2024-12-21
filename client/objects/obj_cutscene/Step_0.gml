/// @description Inserir descrição aqui
with(obj_battle_manager) {
	animating = true;	
}

var _current_action = cutscene[action];
var _arg_length = array_length(_current_action) - 1;

cutscene_skip_percentage = clamp(cutscene_skip_percentage, 0, 1);

switch (_arg_length) {
	case 1:
		script_execute(_current_action[0], _current_action[1]);
		break;
	case 2:
		script_execute(_current_action[0], _current_action[1], _current_action[2]);
		break;
	case 3:
		script_execute(_current_action[0], _current_action[1], _current_action[2], _current_action[3]);
		break;
	case 4:
		script_execute(_current_action[0], _current_action[1], _current_action[2], _current_action[3], _current_action[4]);
		break;
	case 5:
		script_execute(_current_action[0], _current_action[1], _current_action[2], _current_action[3], _current_action[4], _current_action[5]);
		break;
	case 6:
		script_execute(_current_action[0], _current_action[1], _current_action[2], _current_action[3], _current_action[4], _current_action[5], _current_action[6]);
		break;
	default:
		script_execute(_current_action[0]);
		break;
}
