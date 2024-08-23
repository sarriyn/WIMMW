extends State;
class_name WalkingState;

var isWalking : bool;

func _init(pCR : PlayerController, pSC : PlayerStateController) -> void:
	playerControllerReference = pCR;
	playerStateController = pSC;
	isWalking = false;
	anime = playerControllerReference.get_node("Neck/SAS/AnimationPlayer");
	playerVelocity = playerControllerReference.velocity;

func _to_string() -> String:
	return "WalkingState";

func SetState() -> void:
	isWalking = !isWalking;

func GetState() -> bool:
	return isWalking;

#func Update() -> void:
	#super.Update()
	#anime.play("walk", -1, 2.0, false);
	#print("walking UPDATE")
	#anime.play("walk");
