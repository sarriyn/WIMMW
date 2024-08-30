extends State
class_name TabMenuState;

var isTab : bool;
var firstPersonCam : Camera3D;
var tabCam : Camera3D;

func _init(pCR : PlayerController, pSC : PlayerStateController) -> void:
	playerControllerReference = pCR;
	playerStateController = pSC;
	playerVelocity = playerControllerReference.velocity;
	isTab = false;
	anime = playerControllerReference.get_node("Neck/SAS/AnimationPlayer");
	firstPersonCam = playerControllerReference.get_node("Neck/Camera3D");
	tabCam = playerControllerReference.get_node("Neck/tabCam");

func _to_string() -> String:
	return "TabMenuState";

func SetState() -> void:
	isTab = !isTab;

func GetState() -> bool:
	return isTab;

func Update() -> void:
	anime.play("tabMenuPose", -1, 2.0, false);
	if not tabCam.current:
		firstPersonCam.current = true; # Sets firstPersonCam to the current cam (tabCam is no longer the current)
		playerStateController.ChangeState("IdleState");
