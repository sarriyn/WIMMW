extends CharacterBody3D;
class_name PlayerPickupObject;

var interaction : RayCast3D;
var hand : Marker3D;
var pickedObject : RigidBody3D;
var activeObject : bool;#tells physics when to run PickedObjectMove() //optimization//
var pullPower : float;

var playerControllerReference : PlayerController;

func _init(playerController : PlayerController) -> void:
	playerControllerReference = playerController;
	interaction = playerControllerReference.get_node("Neck/Camera3D/interaction");#interaction referes to the players RayCast used for determining if an object is in range to be picked up
	hand = playerControllerReference.get_node("Neck/Camera3D/hand");#hand referes to a Marker3D (basically an empty) that the picked up object will gravitate towards
	interaction.add_exception(playerControllerReference);#add exception to the player's collision body
	pickedObject = null
	activeObject = false
	pullPower = 7.0
	
func PickObject() -> void:
	print(pickedObject)
	var collider = interaction.get_collider()
	if collider != null and collider is RigidBody3D:
		activeObject = true
		pickedObject = collider

func RemoveObject() -> void:
	if pickedObject != null:
		pickedObject = null;

func PickedObjectMove() -> void:
	
	print(pickedObject.position.y)
	if pickedObject != null:

		var a = pickedObject.global_transform.origin
		var b = hand.global_transform.origin
		var distanceVector = b - a 
		var distance = distanceVector.length()

		pickedObject.set_linear_velocity((b-a)*pullPower)#moves the cube around
		if distance > 5.0:#checks if the pickedObject is more that 5 units away
			pickedObject = null; #releases the object if it's out of range
