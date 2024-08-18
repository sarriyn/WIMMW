extends Node;
class_name PlayerDebugging;

var playerControllerReference : PlayerController;
var playerUi : Control;
var fps : Label;
var fpsDefaultText : String
var playerCoordinates : Label;
var playerCoordinatesDefaultText : String
var playerCameraDirectionFacing : Label;
var playerCameraDirectionFacingDefaultText : String;
var playerVelocity : Label;
var playerVelocityDefaultText : String;

func _init(playerController : PlayerController) -> void:
	playerControllerReference = playerController;
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
	playerControllerReference.call_deferred("add_child", playerUi);

func SetFps() -> void:
	fps.text = fpsDefaultText + str(GetFps());

func GetFps() -> float:
	return Engine.get_frames_per_second();

func SetPlayerGlobalCoordinates() -> void:
	playerCoordinates.text = playerCoordinatesDefaultText + str(GetPlayerGlobalCoordinates());

func GetPlayerGlobalCoordinates() -> Vector3:
	return playerControllerReference.global_transform.origin;

func SetPlayerCameraDirectionFacing() -> void:
	playerCameraDirectionFacing.text = playerCameraDirectionFacingDefaultText + str(GetPlayerCameraDirectionFacing());

func GetPlayerCameraDirectionFacing() -> Vector3:
	return -playerControllerReference.get_node("Neck").get_node("Camera3D").transform.basis.z.normalized();

func SetPlayerVelocity() -> void:
	playerVelocity.text = playerVelocityDefaultText + str(GetPlayerVelocity());

func GetPlayerVelocity() -> Vector3:
	return playerControllerReference.velocity;

func SetVisibility() -> void:
	playerUi.visible = !playerUi.visible;

func GetVisibility() -> bool:
	return playerUi.visible;

func Tick() -> void:
	SetFps();
	SetPlayerCameraDirectionFacing();
	SetPlayerGlobalCoordinates();
	SetPlayerVelocity();
