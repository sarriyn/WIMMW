extends Node;
class_name State;

func _to_string() -> String:
	return "";

func Enter() -> void:
	#print("TestEnter");
	pass;

func Exit() -> void:
	#print("TestExit");
	pass;

func Update(_delta : float) -> void:
	#print("TestUpdate");
	pass;

func PhysicsUpdate(_delta : float) -> void:
	#print("TestPhysicsUpdate");
	pass;
