extends CharacterBody3D;
class_name PlayerController;

var playerInputChecker : PlayerInputChecker;
var playerCameraMovement : PlayerCameraMovement;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	playerInputChecker = PlayerInputChecker.new(self); # Initialize PlayerInputChecker and pass self
	playerCameraMovement = PlayerCameraMovement.new(self, 0.5); # Initialize PlayerCameraMovement and pass self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta : float) -> void:
	pass

# Called before all the physics calculations
# NOTE: Capped at 60 FPS
func _physics_process(delta : float) -> void:
	playerInputChecker.InputCheck(delta); # Check player's Input

# Called for input events that were not consumed or handled
# by any nodes in the scene tree or by the UI system.
func _unhandled_input(event : InputEvent) -> void:
	if event is InputEventMouseButton: # If any mouse button is clicked, make the cursor invisible
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);
	elif event.is_action_pressed("ui_cancel"): # If the ESC button is pressed, make the cursor visible
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);

# Called for every input event, and it allows to handle these
# events immediately as they occur.
func _input(event : InputEvent) -> void:
	if event is InputEventMouseMotion:
		playerCameraMovement.CameraMovement(event); # Perform the camera movement
