extends Node3D
class_name SmoothModelInterpolation

var playerControllerReference : PlayerController

var lerpPoint : Node3D
var roboticFPSRig : Node3D

# Euler Camera Smoothing
var lastLerpRotation : Vector3
var smoothedCameraRotationDelta : Vector3
var smoothingFactor : float
# Position
var swayAmount : Vector3
var swaySpeed : float
# Rotation
var swayIntensityLook : Vector3
var lastMousePosition : Vector2
var mouseDelta : Vector2
var lerpOriginalPosition : Vector3
var rVec : float

func _init(playerController : PlayerController):
	lerpPoint = playerController.get_node("Neck/Camera3D/lerpPoint")
	roboticFPSRig = playerController.get_node("Neck/Camera3D/roboticFPSRig")
	
	lastLerpRotation = Vector3.ZERO
	smoothedCameraRotationDelta = Vector3.ZERO
	smoothingFactor = 0.1
	swayAmount = Vector3(0.05, 0.1, 0.05)
	swaySpeed = 5.0
	swayIntensityLook = Vector3(0.1, 0.1, 0.1)
	lastMousePosition = Vector2()
	rVec = 3.0
	playerControllerReference = playerController
	lerpOriginalPosition = lerpPoint.position
	lastLerpRotation = lerpPoint.global_transform.basis.get_euler()
	
func GetMovementInputVector() -> Vector3:
	# Weapon/hands movement based on velocity of the player
	var inputVector = Vector3.ZERO
	inputVector.x = playerControllerReference.velocity.x
	inputVector.y = playerControllerReference.velocity.y
	inputVector.z = playerControllerReference.velocity.z
	return inputVector.normalized()
	
func getLerpPointRotationVector(mouseDelta) -> Vector3:
	# Weapon/hands movement based on mouse movement simulating looking behavior
	var lerpRotationVector = Vector3.ZERO
	lerpRotationVector.x = mouseDelta.x
	lerpRotationVector.y = mouseDelta.y
	return lerpRotationVector.normalized()
	
func smoothModelInterpolationProcess(delta: float) -> void:
	var currentCameraRotation = lerpPoint.global_transform.basis.get_euler()
	var rawCameraRoationDelta = currentCameraRotation - lastLerpRotation
	rawCameraRoationDelta = adjustForWrapAround(rawCameraRoationDelta)
	
	lastLerpRotation = currentCameraRotation
	# Position
	var inputVector = GetMovementInputVector()
	var targetPosition = Vector3(inputVector.x * swayAmount.x, (inputVector.y * swayAmount.y) * 0.222, 0)
	# Rotation
	var rotationVector = getLerpPointRotationVector(mouseDelta)
	var targetRotation = Vector3((rawCameraRoationDelta.y * swayAmount.y) * 10, (rawCameraRoationDelta.x * swayAmount.x) * 10, 0)
	
	# Smoothly update the roboticFPSRig position for sway effect
	roboticFPSRig.position = roboticFPSRig.position.lerp(targetPosition + targetRotation, swaySpeed * delta)

func adjustForWrapAround(rawDelta: Vector3) -> Vector3:
	# Fixes the Euler jumping at 359 and 0.
	for i in range(3): # Check each component (x, y, z) of the vector 
		if rawDelta[i] > PI: # Assuming radians; use 180 for degrees 
			rawDelta[i] -= 2 * PI
		elif rawDelta[i] < -PI:
			rawDelta[i] += 2 * PI
	return rawDelta
