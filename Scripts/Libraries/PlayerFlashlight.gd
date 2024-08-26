extends Node;
class_name PlayerFlashlight;

var flashLight : SpotLight3D;
var playerControllerReference : PlayerController;

func _init(playerController : PlayerController) -> void:
	playerControllerReference = playerController; 
	flashLight = playerController.get_node("Neck/Camera3D/flashlight");
	flashLight.visible = false;

func ToggleFlashLight() -> void:
	flashLight.visible = !flashLight.visible;
