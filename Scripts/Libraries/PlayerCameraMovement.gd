extends CharacterBody3D;
class_name PlayerCameraMovement;

var playerControllerReference : PlayerController;

var mouseSensitivity : float;
var min_pitch : float;
var max_pitch : float;
var yaw : float;
var pitch : float;

var camera : Camera3D;
var neck : Node3D;

# PlayerCameraMovement constructor
# It sets the default values and grabs the PlayerController reference
func _init(playerController : PlayerController, mouseSensitivityDefault : float = 0.1) -> void:
	playerControllerReference = playerController; # Grab reference to PlayerController (attached to Player node)
	mouseSensitivity = mouseSensitivityDefault;
	min_pitch = -90.0;
	max_pitch = 90.0;
	yaw = 0.0;
	pitch = 0.0;
	neck = playerControllerReference.get_node("Neck");
	camera = neck.get_node("Camera3D");

# Performs camera movement for the player
func CameraMovement(event : InputEvent) -> void:
	yaw -= event.relative.x * mouseSensitivity;
	pitch -= event.relative.y * mouseSensitivity;
	
	pitch = clamp(pitch, min_pitch, max_pitch); # Makes sure pitch stays within -90 to 90 degrees

	neck.rotation_degrees.y = yaw;
	camera.rotation_degrees.x = pitch;
