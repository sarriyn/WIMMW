extends State
class_name TabMenuState;

var isTab : bool;
var firstPersonCam : Camera3D;
var tabCam : Camera3D;

func _init(pCR : PlayerController, pSC : PlayerStateController) -> void:
	playerControllerReference = pCR;
	playerStateController = pSC;
	anime = playerControllerReference.get_node("Neck/SAS/AnimationPlayer");
	playerVelocity = playerControllerReference.velocity;
	isTab = false;
	firstPersonCam = playerControllerReference.get_node("Neck/Camera3D");
	tabCam = playerControllerReference.get_node("Neck/tabCam");

func _to_string() -> String:
	return "TabMenuState";

func SetState() -> void:
	isTab = !isTab;

func GetState() -> bool:
	return isTab;

func Update() -> void:
	# If in WalkingState, play the "walk" animation, but also from here
	# It's posible to begin falling (walk off the edge)
	# It's also possible to begin being idle, because you can stop moving
	anime.play("tabMenuPose", -1, 2.0, false); # NOTE, if already in WalkingState, we reset the animation
	if firstPersonCam.current:
		anime.play("IDLESideArm", -1, 2.0, false);
		playerStateController.ChangeState("IdleState");
