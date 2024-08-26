extends CharacterBody3D;
class_name PlayerPickupObject;

const pullPower : float = 7.0;

var interaction : RayCast3D;
var hand : Marker3D;
var pickedObject : RigidBody3D;
# var activeObject : bool; # Tells physics when to run PickedObjectMove() //optimization//

var playerControllerReference : PlayerController;

func _init(playerController : PlayerController) -> void:
	playerControllerReference = playerController;
	interaction = playerControllerReference.get_node("Neck/Camera3D/interaction"); # Interaction referes to the players RayCast used for determining if an object is in range to be picked up
	hand = playerControllerReference.get_node("Neck/Camera3D/hand"); # Hand referes to a Marker3D (basically an empty) that the picked up object will gravitate towards
	interaction.add_exception(playerControllerReference); # Add exception to the player's collision body
	pickedObject = null
	# activeObject = false
	
func PickObject() -> void:
	var collider = interaction.get_collider()
	if collider != null and collider is RigidBody3D:
		# activeObject = true # Useless as of right now?
		pickedObject = collider

func RemoveObject() -> void:
	pickedObject = null;

func TryPickupObject() -> void:
	if pickedObject == null:
		PickObject();
	else:
		RemoveObject();

func PickedObjectMove() -> void:
	if pickedObject != null:
		var a = pickedObject.global_transform.origin
		var b = hand.global_transform.origin
		var distanceVector = b - a 
		var distance = distanceVector.length()

		pickedObject.set_linear_velocity((b-a)*pullPower) # Moves the cube around
		if distance > 5.0: # Checks if the pickedObject is more that 5 units away
			RemoveObject(); # Releases the object if it's out of range
