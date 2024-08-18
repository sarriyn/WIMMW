extends Node;
class_name PlayerStateController;

var playerControllerReference : PlayerController;
var states : Dictionary;
var currentState : State;

func _process(delta):
	currentState.Update(delta);

func _init(playerController : PlayerController):
	playerControllerReference = playerController;
	
	states = {
		"IdleState" = IdleState.new(),
		"WalkingState" = WalkingState.new()
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
