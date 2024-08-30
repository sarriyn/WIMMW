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

# PlayerCameraMovement constructor
# It sets the default values and grabs the PlayerController reference
func _init(playerController : PlayerController, mouseSensitivityDefault : float = 0.1) -> void:
	playerControllerReference = playerController; # Grab reference to PlayerController (attached to Player node)
	mouseSensitivity = mouseSensitivityDefault;
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
