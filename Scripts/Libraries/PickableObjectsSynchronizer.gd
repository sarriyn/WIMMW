extends MultiplayerSynchronizer;
class_name PickableObjectsSynchronizer;

var pickableObjects : Dictionary;
var pickableObjectsToSynchronize : Dictionary;

func _ready() -> void:
	var testBox : RigidBody3D = self.get_node("testBox");
	var testBox2 : RigidBody3D = self.get_node("testBox2");
	# NOTE: This is just to show how we will want to add to the dictionary
	pickableObjects = {};
	# NOTE: [reference, multiplayerAuthority, isLocked], the third value tells us whether a player is using it or not
	OnPickableObjectCreation(testBox);
	OnPickableObjectCreation(testBox2);

# Function that is attached to "body_entered" signal
# If a local peer controlling pickable-object A hits pickable-object B, 
# Pickable-object B will be synchronized with everyone else based on local peer's pickable-object physics
# Sends initial synchronization data for the current frame
# UNUSED FUNCTION
#func OnBodyEntered(body) -> void:
#	if body is RigidBody3D and pickableObjects.has(body.name):
#		SendObjectPhysicsData.rpc(body.name, body.global_transform.origin, body.global_transform.basis, body.linear_velocity, body.angular_velocity);
#		AddToSynchronize(body.name);

# Keeps synchronizing information with other peers until the object is considered completely stationary
# UNUSED FUNCTION
#func SynchronizeObjects() -> void:
#	for key in pickableObjectsToSynchronize:
#		if pickableObjectsToSynchronize[key]:
#			var pickableObject : RigidBody3D = pickableObjectsToSynchronize[key];
#			if pickableObject.linear_velocity == Vector3.ZERO and pickableObject.angular_velocity == Vector3.ZERO:
#				pickableObjectsToSynchronize[key] = null;
#				print("awd")
#			SendObjectPhysicsData.rpc(pickableObject.name, pickableObject.global_transform.origin, pickableObject.global_transform.basis, pickableObject.linear_velocity, pickableObject.angular_velocity);

# Runs SynchronizeObjects() every physics process tick
# UNUSED FUNCTION
#func _physics_process(_delta: float) -> void:
#	SynchronizeObjects();

# Sees if object is locked (we assume starts synchronized)
func GetIfObjectLocked(objectName : String) -> bool:
	return pickableObjects[objectName][2];

# Adds a pickable-object to be synchronized every frame
# UNUSED FUNCTION
#func AddToSynchronize(objectName : String) -> void:
#	pickableObjectsToSynchronize[objectName] = pickableObjects[objectName][0];

# Sends physics data of object currently picked up to local peer and all other clients
@rpc("any_peer", "call_local")
func SendObjectPhysicsData(objectName : String, objectPos : Vector3, objectRot : Basis, objectLinearVelocity : Vector3, objectAngularVelocity) -> void:
	# NOTE: This function could be separated into two, one for local peer and one for others
	# Doing pickableObects[objectName][0] requires a trip to memory, we already have this on hand 
	# for the local peer when this function is called
	var object : RigidBody3D = pickableObjects[objectName][0];
	object.global_transform.origin = objectPos;
	object.global_transform.basis = objectRot;
	object.set_linear_velocity(objectLinearVelocity);
	object.set_angular_velocity(objectAngularVelocity);

# Upon creating a pickable-obect, this function should be called
# Runs on local peer and all other clients
@rpc("any_peer", "call_local")
func OnPickableObjectCreation(pickableObject : RigidBody3D) -> void:
	#pickableObject.connect("body_entered", OnBodyEntered);
	pickableObjects[pickableObject.name] = [pickableObject, pickableObject.get_multiplayer_authority(), false];

# Sets the pickable-object to no longer be synchronized
# Runs on local peer and all other clients
@rpc("any_peer", "call_local")
func RemoveFromSynchronize(objectName : String) -> void:
	pickableObjectsToSynchronize[objectName] = null;

# Sets the multiplayer authority to the given authority ID
# Sets the local object's multiplayer authority to given authority ID
# Synchronized current authority controlling object, and if object is locked
@rpc("any_peer", "call_local")
func OnChangePickableObjectsMultiplayerAuthorityRPC(objectName : String, authorityID : int) -> void:
	var pickableObject : RigidBody3D = pickableObjects[objectName][0];
	
	#pickableObject.contact_monitor = true; # This allows for functions to be attached to signals
	#pickableObject.max_contacts_reported = 1; # This allows for collisions to be detected
	pickableObject.set_multiplayer_authority(authorityID);
	
	pickableObjects[objectName][1] = authorityID;
	pickableObjects[objectName][2] = true;
	
	RemoveFromSynchronize.rpc(objectName)

# Synchronized setting object to no longer being locked
@rpc("any_peer", "call_local")
func OnChangePickableObjectsMultiplayerLockedRPC(objectName : String) -> void:
	var pickableObject : RigidBody3D = pickableObjects[objectName][0];
	
	#pickableObject.contact_monitor = false; # We want to set this to false once we are done with it, for performance reasons
	#pickableObject.max_contacts_reported = 0; # We also want to set this to 0 to make sure
	
	pickableObjects[objectName][2] = false;
