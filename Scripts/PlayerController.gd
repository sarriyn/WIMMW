extends CharacterBody3D
class_name PlayerController

var playerInputChecker : PlayerInputChecker
var playerCameraMovement : PlayerCameraMovement
var playerDebugging : PlayerDebugging
var playerStateController : PlayerStateController
var playerRPCSynchronizer : PlayerRPCSynchronizer
var smoothModelInterpolation : SmoothModelInterpolation

# Called when the node enters the scene tree, but does not wait for the children to also enter
func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int()) # Set multiplayer authority for this specific game instance
	$Neck/Camera3D.current = is_local_player() # Set the camera current if this is the local player

# Method to determine if this is the local player
func is_local_player() -> bool:
	return multiplayer.get_unique_id() == name.to_int()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(false) # Stop from _process being called while Player is initializing
	self.global_transform.origin = Vector3(-6, 1, -111) # Spawn the player at position (-6, 1, -111)
	playerInputChecker = PlayerInputChecker.new(self) # Initialize PlayerInputChecker and pass self
	playerCameraMovement = PlayerCameraMovement.new(self, 0.5) # Initialize PlayerCameraMovement and pass self
	playerDebugging = PlayerDebugging.new(self)
	playerStateController = PlayerStateController.new(self)
	smoothModelInterpolation = SmoothModelInterpolation.new(self)
	
	var robotic_fps_rig = get_node("Neck/Camera3D/roboticFPSRig") # Reference to the first-person arm rig
	var third_person_mesh = get_node("Neck/SAS/Armature/Skeleton3D/Cylinder_001") # Reference to the third-person mesh (Cylinder_001)
	var battery_chamber_l = get_node("Neck/SAS/Armature/Skeleton3D/battery chamber low") # Reference to the left battery chamber

	# Local player-specific setup
	if is_local_player():
		robotic_fps_rig.visible = true # Ensure the first-person arms are visible to the local player
		third_person_mesh.visible = false # Hide the third-person mesh from the local player
		battery_chamber_l.visible = false # Hide the left battery chamber from the local player
	else:
		robotic_fps_rig.visible = false # Hide the first-person arms for remote players
		third_person_mesh.visible = true # Ensure the third-person mesh is visible to other players
		battery_chamber_l.visible = true # Ensure the left battery chamber is visible to other players

	set_process(true) # Begin _process being called, initializing finished

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta : float) -> void:
	pass

# Called before all the physics calculations
# NOTE: Capped at 60 FPS
func _physics_process(delta : float) -> void:
	if is_local_player():
		playerInputChecker.InputCheck(delta) # Check player's Input
		if playerDebugging.GetVisibility(): # Placed here for accuracy of data
			playerDebugging.Tick(delta)
	playerStateController.UpdateState()
	smoothModelInterpolation.smoothModelInterpolationProcess(delta)

# Called for input events that were not consumed or handled
# by any nodes in the scene tree or by the UI system.
func _unhandled_input(event : InputEvent) -> void:
	if event is InputEventMouseButton: # If any mouse button is clicked, make the cursor invisible
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);
	elif event.is_action_pressed("ui_cancel"): # If the ESC button is pressed, make the cursor visible
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);
		#self.get_parent().get_parent().get_parent().visible = true; # This will remain specific to the player (MainMenu)

# Called for every input event, and it allows to handle these
# events immediately as they occur.
func _input(event : InputEvent) -> void:
	if event is InputEventMouseMotion:
		playerCameraMovement.CameraMovement(event); # Perform the camera movement
