extends State;
class_name WalkingState;

var isWalking : bool;
var firstPersonCam : Camera3D;
var tabCam : Camera3D;

func _init(pCR : PlayerController, pSC : PlayerStateController) -> void:
	playerControllerReference = pCR;
	playerStateController = pSC;
	anime = playerControllerReference.get_node("Neck/SAS/AnimationPlayer");
	firstPersonCam = playerControllerReference.get_node("Neck/Camera3D");
	tabCam = playerControllerReference.get_node("Neck/tabCam");
	playerVelocity = playerControllerReference.velocity;
	isWalking = false;

func _to_string() -> String:
	return "WalkingState";

func SetState() -> void:
	isWalking = !isWalking;

func GetState() -> bool:
	return isWalking;

func Update() -> void:
	# If in WalkingState, play the "walk" animation, but also from here
	# It's posible to begin falling (walk off the edge)
	# It's also possible to begin being idle, because you can stop moving
	anime.play("walk", -1, 2.0, false); # NOTE, if already in WalkingState, we reset the animation
	if not playerControllerReference.is_on_floor() and (absf(playerControllerReference.velocity.y) > 0) and not tabCam.current:
		playerStateController.ChangeState("FallingState");
	elif (absf(playerControllerReference.velocity.x) + absf(playerControllerReference.velocity.z)) == 0 and not tabCam.current:
		playerStateController.ChangeState("IdleState");
	elif tabCam.current:
		playerStateController.ChangeState("TabMenuState");
