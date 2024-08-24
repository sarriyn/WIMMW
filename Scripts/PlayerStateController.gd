extends Node;
class_name PlayerStateController;

var playerControllerReference : PlayerController;
var states : Dictionary;
var currentState : State;

func _init(playerController : PlayerController):
	playerControllerReference = playerController;
	
	states = {
		"IdleState" = IdleState.new(playerControllerReference, self),
		"WalkingState" = WalkingState.new(playerControllerReference, self),
		"FallingState" = FallingState.new(playerControllerReference, self)
	};
	
	currentState = states["IdleState"];

func ChangeState(newStateName : String) -> void:
	currentState = states[newStateName];

func GetState(stateName : String) -> State:
	return states[stateName];

func GetCurrentState() -> State:
	return currentState;

func UpdateState() -> void:
	currentState.Update();
