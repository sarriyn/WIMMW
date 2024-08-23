extends State;
class_name IdleState;

var isIdle : bool;


func _init(pCR : PlayerController, pSC : PlayerStateController) -> void:
	playerControllerReference = pCR
	playerStateController = pSC
	isIdle = true;
	anime = playerControllerReference.get_node("Neck/SAS/AnimationPlayer");
	playerVelocity = playerControllerReference.velocity;

func _to_string() -> String:
	return "IdleState";

func SetState() -> void:
	isIdle = !isIdle;

func GetState() -> bool:
	return isIdle;

#func Update() -> void:
	#super.Update()
	#anime.play("idle", -1, 2.0, false);
	#print("idle UPDATE")
	#anime.play("idle");
	
