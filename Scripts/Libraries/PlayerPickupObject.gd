extends RayCast3D;
class_name PlayerPickupObject;

const pullPower : float = 17.0;

var pickableObjectsSynchronizer : PickableObjectsSynchronizer;

var interaction : RayCast3D;
var hand : Marker3D;
var pickedObject : RigidBody3D;
# var activeObject : bool; # Tells physics when to run PickedObjectMove() //optimization//

var playerControllerReference : PlayerController;

func InitializeNode(playerController : PlayerController) -> void:
	playerControllerReference = playerController;
	interaction = playerControllerReference.get_node("Neck/Camera3D/interaction"); # Interaction referes to the players RayCast used for determining if an object is in range to be picked up
	hand = playerControllerReference.get_node("Neck/Camera3D/hand"); # Hand referes to a Marker3D (basically an empty) that the picked up object will gravitate towards
	interaction.add_exception(playerControllerReference); # Add exception to the player's collision body
	pickableObjectsSynchronizer = playerControllerReference.get_parent().get_node("PickableObjectsSynchronizer");
	pickedObject = null
	# activeObject = false

func PickObject() -> void:
	var collider = interaction.get_collider()
	if collider != null and collider is RigidBody3D:
		if not pickableObjectsSynchronizer.GetIfObjectLocked(collider.name):
			pickedObject = collider;
			# activeObject = true # Useless as of right now?
			pickableObjectsSynchronizer.OnChangePickableObjectsMultiplayerAuthorityRPC.rpc(pickedObject.name, playerControllerReference.get_multiplayer_authority());

func RemoveObject() -> void:
	pickableObjectsSynchronizer.OnChangePickableObjectsMultiplayerLockedRPC.rpc(pickedObject.name);
	pickedObject = null;

func TryPickupObject() -> void:
	if pickedObject == null:
		PickObject();
	else:
		RemoveObject();

func PickedObjectMove() -> void:
	if pickedObject != null:
		var a : Vector3 = pickedObject.global_transform.origin
		var b : Vector3 = hand.global_transform.origin
		var distanceVector : Vector3 = b - a
		var distance : float = distanceVector.length()
		var linearVelocity : Vector3 = distanceVector * pullPower

		pickableObjectsSynchronizer.SendObjectPhysicsData.rpc(pickedObject.name, pickedObject.global_transform.origin, pickedObject.global_transform.basis, linearVelocity, pickedObject.angular_velocity);
		if distance > 5.0: # Checks if the pickedObject is more that 5 units away
			RemoveObject(); # Releases the object if it's out of range
