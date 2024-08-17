extends CharacterBody3D;
class_name PlayerMovementPhysics;

var playerControllerReference : PlayerController;

var acceleration : float;
var deceleration : float;
var speed : float;
var fallAcceleration : float;
var airControl : float;
var playerVelocity : Vector3;
var jumpVelocity : float;
var direction : Vector3;
var gravity : float;

var camera : Camera3D;
var neck : Node3D;

# PlayerMovementPhysics constructor
# It sets the instance's variables to their defaults,
# and grabs the PlayerController reference from the parameter
func _init(playerController : PlayerController) -> void:
	acceleration = 3.0
	deceleration = 8.333
	speed = 12.0;
	fallAcceleration = 4.5;
	airControl = 0.1
	jumpVelocity = 6.666
	playerVelocity = Vector3.ZERO;
	direction = Vector3.ZERO;
	gravity = ProjectSettings.get_setting("physics/3d/default_gravity");
	playerControllerReference = playerController;
	neck = playerControllerReference.get_node("Neck");
	camera = neck.get_node("Camera3D");

# Moves the player to the right
func MoveRight() -> void:
	direction.x += 1;

# Moves the player to the left
func MoveLeft() -> void:
	direction.x -= 1;

# Moves the player forward
func MoveForward() -> void:
	direction.z -= 1;

# Moves the player backward
func MoveBackward() -> void:
	direction.z += 1;

# Makes the player jump, if they're on a floor
func Jump(delta) -> void:
	if playerControllerReference.is_on_floor():
		if playerVelocity.y > 0:
			playerVelocity.y = 0
		else:
			playerVelocity.y  = jumpVelocity

# Normalizes the direction if it's not ZERO
func DirectionNormalize() -> void:
	if direction != Vector3.ZERO:
		direction = (neck.transform.basis * direction).normalized(); # This makes the player go in the direction the camera is facing

# Makes the PlayerController's velocity to the playerVelocity, after calculations
# Uses the simple move_and_slide() function
# Horizontal and Vertical Velocity Adjustment with Collision Bounce
func HorizontalAndVerticalVelocityAdjust(delta : float) -> void:
	var targetVelocity = direction * speed
	var effectiveDecel = acceleration if direction.length() > 0 else deceleration

	if direction != Vector3.ZERO:
		targetVelocity = direction * speed

	if playerControllerReference.is_on_floor():
		#print(" is on floor ")
		playerVelocity.x = lerp(playerVelocity.x, targetVelocity.x, delta * effectiveDecel)
		playerVelocity.z = lerp(playerVelocity.z, targetVelocity.z, delta * effectiveDecel)
	else:
		playerVelocity.y += gravity * delta
		#print(" is not on floor ")
		playerVelocity.x = lerp(playerVelocity.x, targetVelocity.x, delta * acceleration * airControl)
		playerVelocity.z = lerp(playerVelocity.z, targetVelocity.z, delta * acceleration * airControl)

	# Handle collisions and apply bounce based on speed
	if !playerControllerReference.is_on_floor() and playerControllerReference.get_slide_collision_count() > 0:
		for i in range(playerControllerReference.get_slide_collision_count()):
			var collision = playerControllerReference.get_slide_collision(i)
			var collision_normal = collision.get_normal()
			
			if collision_normal.dot(Vector3.UP) < 0.1:  # Check if the collision is mostly horizontal
				var bounce_factor = 1.5  # You can adjust this factor to control how bouncy the collision is
				var impact_speed = playerVelocity.dot(collision_normal)# .dot returns the dot product
				var bounce_velocity = collision_normal * -impact_speed * bounce_factor
				
				playerVelocity.x += bounce_velocity.x
				playerVelocity.z += bounce_velocity.z
				break

	playerControllerReference.velocity = playerVelocity;
	playerControllerReference.move_and_slide()

	direction = Vector3.ZERO  # This is important, otherwise the player will jitter
