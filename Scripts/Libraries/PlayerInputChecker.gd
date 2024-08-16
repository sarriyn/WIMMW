extends CharacterBody3D;
class_name PlayerInputChecker;

var playerMovementPhysics : PlayerMovementPhysics;
var playerControllerReference : PlayerController;

# PlayerInputChecker constructor
# It sets the PlayerController reference from the parameter,
# and it creates an instance of the PlayerMovementPhysics class
func _init(playerController : PlayerController) -> void:
	playerControllerReference = playerController;
	playerMovementPhysics = PlayerMovementPhysics.new(playerControllerReference);

# Checks the user's input for WASD and Space
# It performs the physics depending on what the user pressed
func InputCheck(delta : float) -> void:
	if Input.is_action_just_pressed("jump"):
		playerMovementPhysics.Jump();
	if Input.is_action_pressed("move_right"):
		playerMovementPhysics.MoveRight();
	if Input.is_action_pressed("move_left"):
		playerMovementPhysics.MoveLeft();
	if Input.is_action_pressed("move_backward"):
		playerMovementPhysics.MoveBackward();
	if Input.is_action_pressed("move_forward"):
		playerMovementPhysics.MoveForward();

	playerMovementPhysics.DirectionNormalize();
	playerMovementPhysics.HorizontalAndVerticalVelocityAdjust(delta);
