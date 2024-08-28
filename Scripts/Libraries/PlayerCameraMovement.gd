extends CharacterBody3D;
class_name PlayerCameraMovement;

const min_pitch : float = -90.0;
const max_pitch : float = 90.0;

var playerControllerReference : PlayerController;

var mouseSensitivity : float;
var yaw : float;
var pitch : float;

var camera : Camera3D;
var neck : Node3D;
var tabCam : Camera3D;

var armsRigMesh : Node3D;
var playerMesh : Node3D;
var sideArmMesh : Node3D;

# PlayerCameraMovement constructor
# It sets the default values and grabs the PlayerController reference
func _init(playerController : PlayerController, mouseSensitivityDefault : float = 0.1) -> void:
	playerControllerReference = playerController; # Grab reference to PlayerController (attached to Player node)
	mouseSensitivity = mouseSensitivityDefault;
	yaw = 0.0;
	pitch = 0.0;
	neck = playerControllerReference.get_node("Neck");
	camera = neck.get_node("Camera3D");
	tabCam = neck.get_node("tabCam");
	armsRigMesh = playerControllerReference.get_node("Neck/Camera3D/roboticFPSRig");#the arms mesh that is intended for first person viewing
	playerMesh = playerControllerReference.get_node("Neck/SAS/Armature/Skeleton3D/Cylinder_001");#player mesh that is intended for 3rd person viewing in multiplayer and tabs
	sideArmMesh = playerControllerReference.get_node("Neck/SAS/Armature/Skeleton3D/battery chamber low");#sidearm mesh

# Performs camera movement for the player
func CameraMovement(event : InputEvent) -> void:
	yaw -= event.relative.x * mouseSensitivity;
	pitch -= event.relative.y * mouseSensitivity;
	pitch = clamp(pitch, min_pitch, max_pitch); # Makes sure pitch stays within -90 to 90 degrees
	neck.rotation_degrees.y = yaw;
	camera.rotation_degrees.x = pitch;

func TabMenu() -> void:#swaps the visibility, acts as a toggle between the different camera views while in the tabMenu
	armsRigMesh.visible = !armsRigMesh.visible
	playerMesh.visible = !playerMesh.visible
	sideArmMesh.visible = sideArmMesh.visible
	tabCam.current = !tabCam.current#swaps the camera
