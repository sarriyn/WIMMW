extends State;
class_name IdleState;

var isIdle : bool;
var firstPersonCam : Camera3D;
var tabCam : Camera3D;

func _init(pCR : PlayerController, pSC : PlayerStateController) -> void:
	playerControllerReference = pCR
	playerStateController = pSC
	anime = playerControllerReference.get_node("Neck/SAS/AnimationPlayer");
	firstPersonCam = playerControllerReference.get_node("Neck/Camera3D");
	tabCam = playerControllerReference.get_node("Neck/tabCam");
	playerVelocity = playerControllerReference.velocity;
	isIdle = true;

func _to_string() -> String:
	return "IdleState";

func SetState() -> void:
	isIdle = !isIdle;

func GetState() -> bool:
	return isIdle;

func Update() -> void:
	# If in IdleState, play the "idle" animation, but also from here
	# It's possible to begin walking
	# It's also possible to begin falling (JUMPING)
	anime.play("IDLESideArm", -1, 2.0, false);
	# IF IN THIS FRAME WE BEGIN WALKING, CHANGE STATE, OTHERWISE STAY.
	if playerControllerReference.is_on_floor() and (absf(playerControllerReference.velocity.x) + absf(playerControllerReference.velocity.z) >= threshold) and not tabCam.current:
		playerStateController.ChangeState("WalkingState");
	elif not playerControllerReference.is_on_floor() and absf(playerControllerReference.velocity.y) > 0 and not tabCam.current:
		playerStateController.ChangeState("FallingState");
	elif tabCam.current:
		playerStateController.ChangeState("TabMenuState");
