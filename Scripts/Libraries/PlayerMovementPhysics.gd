extends CharacterBody3D;
class_name PlayerMovementPhysics;

var playerControllerReference : PlayerController;

var speed : float;
var fallAcceleration : float;
var targetVelocity : Vector3;
var direction : Vector3;
var gravity : float;

var camera : Camera3D;
var neck : Node3D;

# PlayerMovementPhysics constructor
# It sets the instance's variables to their defaults,
# and grabs the PlayerController reference from the parameter
func _init(playerController : PlayerController) -> void:
	speed = 7.0;
	fallAcceleration = 9.81;
	targetVelocity = Vector3.ZERO;
	direction = Vector3.ZERO;
	gravity = ProjectSettings.get_setting("physics/3d/default_gravity");
	playerControllerReference = playerController;
	neck = playerControllerReference.get_node("Neck");
	camera = neck.get_node("Camera3D");

# Moves the player to the right
func MoveRight() -> void:
	direction.x += 1;

# Moves the player to the left
func MoveLeft() -> void:
	direction.x -= 1;

# Moves the player forward
func MoveForward() -> void:
	direction.z -= 1;

# Moves the player backward
func MoveBackward() -> void:
	direction.z += 1;

# Makes the player jump, if they're on a floor
func Jump() -> void:
	if playerControllerReference.is_on_floor():
		targetVelocity.y = fallAcceleration;

# Normalizes the direction if it's not ZERO
func DirectionNormalize() -> void:
	if direction != Vector3.ZERO:
		direction = (neck.transform.basis * direction).normalized(); # This makes the player go in the direction the camera is facing

# Makes the PlayerController's velocity to the targetVelocity, after calculations
# Uses the simple move_and_slide() function
func HorizontalAndVerticalVelocityAdjust(delta : float) -> void:
	targetVelocity.x = direction.x * speed;
	targetVelocity.z = direction.z * speed;
	
	if not playerControllerReference.is_on_floor(): # If player falling, apply gravity
		targetVelocity.y = targetVelocity.y - (gravity * delta);
	
	playerControllerReference.velocity = targetVelocity;
	playerControllerReference.move_and_slide();
	
	if playerControllerReference.is_on_floor(): # If player on the floor, reset targetVelocity on the Y-axis
		targetVelocity.y = 0;
	
	direction = Vector3.ZERO; # This is important, otherwise the player will jitter
