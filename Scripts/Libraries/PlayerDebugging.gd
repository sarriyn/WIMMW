extends Node;
class_name PlayerDebugging;

var playerControllerReference : PlayerController;
var playerCamera : Camera3D;
var playerUi : Control;
var fps : Label;
var fpsDefaultText : String
var playerCoordinates : Label;
var playerCoordinatesDefaultText : String
var playerCameraDirectionFacing : Label;
var playerCameraDirectionFacingDefaultText : String;
var playerVelocity : Label;
var playerVelocityDefaultText : String;

# Constructor that initializes the debug menu values, mostly grabbing Text Labels and other nodes
func _init(playerController : PlayerController) -> void:
	playerControllerReference = playerController;
	playerCamera = playerControllerReference.get_node("Neck").get_node("Camera3D"); # Cache it for efficiency
	playerUi = preload("res://Scenes/DebugMenu.tscn").instantiate();
	playerUi.visible = false;
	var MenuContainer = playerUi.get_node("MenuContainer");
	fps = MenuContainer.get_node("Fps");
	fpsDefaultText = fps.text;
	playerCoordinates = MenuContainer.get_node("PlayerCoordinates");
	playerCoordinatesDefaultText = playerCoordinates.text;
	playerCameraDirectionFacing = MenuContainer.get_node("PlayerCameraDirectionFacing");
	playerCameraDirectionFacingDefaultText = playerCameraDirectionFacing.text;
	playerVelocity = MenuContainer.get_node("PlayerVelocity");
	playerVelocityDefaultText = playerVelocity.text;
	playerControllerReference.add_child(playerUi);

# Sets the visibility of the debug menu
# If true then false, if false then true
func SetVisibility() -> void:
	playerUi.visible = !playerUi.visible;

# Get whether or not the debug menu is visible
func GetVisibility() -> bool:
	return playerUi.visible;

# Tasks to perform each tick
func Tick() -> void:
	fps.text = fpsDefaultText + str(Engine.get_frames_per_second());
	playerCoordinates.text = playerCoordinatesDefaultText + str(playerControllerReference.global_transform.origin);
	playerCameraDirectionFacing.text = playerCameraDirectionFacingDefaultText + str(-playerCamera.transform.basis.z.normalized());
	playerVelocity.text = playerVelocityDefaultText + str(playerControllerReference.velocity);
