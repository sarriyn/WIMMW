extends MultiplayerSynchronizer;
class_name PickableObjectsSynchronizer;

var pickableObjects : Dictionary;

func _ready() -> void:
	var testBox : RigidBody3D = self.get_node("testBox");
	# NOTE: This is just to show how we will want to add to the dictionary
	pickableObjects = {};
	# NOTE: [reference, multiplayerAuthority, isLocked], the second value tells us whether a player is using it or not
	pickableObjects[testBox.name] = [testBox, testBox.get_multiplayer_authority(), false];

# Local function to see if object is locked (we assume starts synchronized)
func GetIfObjectLocked(objectName : String) -> bool:
	return pickableObjects[objectName][2];

# Sets the multiplayer authority to the given authority ID
# Sets the local object's multiplayer authority to given authority ID
# Synchronized current authority controlling object, and if object is locked
@rpc("any_peer", "call_local")
func OnChangePickableObjectsMultiplayerAuthorityRPC(objectName : String, authorityID : int) -> void:
	set_multiplayer_authority(authorityID);
	pickableObjects[objectName][0].set_multiplayer_authority(authorityID);
	pickableObjects[objectName][1] = authorityID;
	pickableObjects[objectName][2] = true;

# Synchronized setting object to no longer being locked
@rpc("any_peer", "call_local")
func OnChangePickableObjectsMultiplayerLockedRPC(objectName : String) -> void:
	pickableObjects[objectName][2] = false;
