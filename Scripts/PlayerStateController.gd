extends Node;
class_name PlayerStateController;

var playerControllerReference : PlayerController;
var states : Dictionary;
var currentState : State;

func _init(playerController : PlayerController):
	playerControllerReference = playerController;
	
	states = {
		"IdleState" = IdleState.new(playerControllerReference, self),
		"WalkingState" = WalkingState.new(playerControllerReference, self)
	};
	
	currentState = states["IdleState"];

func ChangeState(newStateName : String) -> void:
	if GetState(newStateName):
		currentState.Exit();
	currentState = states[newStateName];
	currentState.Enter();

func GetState(stateName : String) -> State:
	return states[stateName];

func GetCurrentState() -> State:
	return currentState;

func UpdateState() -> void:
	currentState.Update();
