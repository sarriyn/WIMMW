extends State;
class_name WalkingState;

var isWalking : bool;

func _to_string() -> String:
	return super._to_string() + str(isWalking);

func _init() -> void:
	isWalking = false;

func SetState() -> void:
	isWalking = !isWalking;

func GetState() -> bool:
	return isWalking;
