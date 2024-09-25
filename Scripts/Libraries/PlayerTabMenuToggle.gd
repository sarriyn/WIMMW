extends Node;
class_name PlayerTabMenuToggle;

var playerControllerReference : PlayerController;
var playerRPCSynchronizer : PlayerRPCSynchronizer;

var firstPersonCam : Camera3D;
var tabCam : Camera3D;
var armsRigMesh : Node3D;
var playerMesh : MeshInstance3D;
var sideArmMesh : BoneAttachment3D;

func _init(playerController : PlayerController) -> void:
	playerControllerReference = playerController;
	playerRPCSynchronizer = playerControllerReference.playerRPCSynchronizer;
	firstPersonCam = playerControllerReference.get_node("Neck/Camera3D");
	tabCam = playerControllerReference.get_node("Neck/tabCam");
	armsRigMesh = playerControllerReference.get_node("Neck/Camera3D/roboticFPSRig"); # The arms mesh that is intended for first person viewing
	playerMesh = playerControllerReference.get_node("Neck/SAS/Armature/Skeleton3D/Cylinder_001"); # Player mesh that is intended for 3rd person viewing in multiplayer and tabs
	sideArmMesh = playerControllerReference.get_node("Neck/SAS/Armature/Skeleton3D/battery chamber low"); # Sidearm mesh

func TabMenu() -> void: # Swaps the visibility, acts as a toggle between the different camera views while in the tabMenu
	armsRigMesh.visible = !armsRigMesh.visible
	playerMesh.visible = !playerMesh.visible
	sideArmMesh.visible = !sideArmMesh.visible
	tabCam.current = !tabCam.current # Swaps the camera
