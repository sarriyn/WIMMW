extends Node;
class_name State;

var playerControllerReference : PlayerController;
var threshold : float = 0.7;
var playerStateController : PlayerStateController;
var anime : AnimationPlayer;
var playerVelocity : Vector3;

func Enter() -> void:
	pass;

func Exit() -> void:
	pass;

func Update() -> void:
	#print(absf(playerVelocity.x + playerVelocity.z), " walking");
	
	#print(playerStateController)
	#print(playerControllerReference);
	if playerStateController.currentState is IdleState:
		# If in IdleState, play the "idle" animation, but also from here
		# It's possible to begin walking
		# It's also possible to begin falling (JUMPING)
		anime.play("idle", -1, 2.0, false);
		# IF IN THIS FRAME WE BEGIN WALKING, CHANGE STATE, OTHERWISE STAY.
		if playerControllerReference.is_on_floor() and (absf(playerControllerReference.velocity.x) + absf(playerControllerReference.velocity.z) >= threshold):
			anime.play("walk", -1, 2.0, false);
			playerStateController.ChangeState("WalkingState");
		elif not playerControllerReference.is_on_floor() and absf(playerControllerReference.velocity.y) > 0:
			anime.play("falling", -1, 2.0, false);
			playerStateController.ChangeState("FallingState");
	elif playerStateController.currentState is WalkingState:
		# If in WalkingState, play the "walk" animation, but also from here
		# It's posible to begin falling (walk off the edge)
		# It's also possible to begin being idle, because you can stop moving
		anime.play("walk", -1, 2.0, false); # NOTE, if already in WalkingState, we reset the animation
		if not playerControllerReference.is_on_floor() and (absf(playerControllerReference.velocity.y) > 0):
			anime.play("falling", -1, 2.0, false);
			playerStateController.ChangeState("FallingState");
		elif (absf(playerControllerReference.velocity.x) + absf(playerControllerReference.velocity.z)) == 0:
			anime.play("IDLESideArm", -1, 2.0, false);
			playerStateController.ChangeState("IdleState");
	elif playerStateController.currentState is FallingState:
		# If in FallingState, play the "falling" animation, but also from here
		# It's possible to begin idle (we landed), but it's NOT possible to be running
		# Or it can be.. but convoluted
		anime.play("falling", -1, 2.0, false);
		if playerControllerReference.velocity == Vector3.ZERO and playerControllerReference.is_on_floor(): # We landed this frame
			anime.play("IDLESideArm", -1, 2.0, false); # NOTE, if already in FallingState, we reset the animation
			playerStateController.ChangeState("IdleState");

func PhysicsUpdate(_delta : float) -> void:
	pass;
