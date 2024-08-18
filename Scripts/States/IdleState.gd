extends State;
class_name IdleState;

var isIdle : bool;

func _init() -> void:
	isIdle = true;

func _to_string() -> String:
	return super._to_string() + str(isIdle);

func SetState() -> void:
	isIdle = !isIdle;

func GetState() -> bool:
	return isIdle;
