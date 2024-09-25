class_name SpatialAudioPlayer3D extends AudioStreamPlayer3D

@export var max_raycast_distance : float = 30.0			#How far we will cast rays for spatial audio
@export var update_frequency_seconds : float = 0.5		#How often we update spatial audio
@export var max_reverb_wetness : float = 0.5			#The max amount of reverb wetness applied to the sound
@export var wall_lowpass_cutoff_amount : int = 600		#The lowpass amount as if the listener is standing directly behind a wall
@export var lerp_speed_modifier : float = 1.0

var _raycast_array : Array = []							#Will contain all of the raycasts
var _distance_array : Array = [0,0,0,0,0,0,0,0,0,0] 	#The lazily updated distance array
var _last_update_time : float = 0.0						#Time since the last spatial audio update
var _update_distances : bool = true						#Should distances be updated
var _current_raycast_index : int = 0					#The current raycast to be updated

#Audio bus for this spatial audio player
var _audio_bus_idx = null
var _audio_bus_name = ""

#Effects
var _reverb_effect : AudioEffectReverb
var _lowpass_filter : AudioEffectLowPassFilter

#Target parameters (Will lerp over time)
var _target_lowpass_cutoff : float = 20000
var _target_reverb_room_size : float = 0.0
var _target_reverb_wetness : float = 0.0
var _target_volume_db : float = 0.0

func _ready():
	#Create an audio bus to control the effects
	_audio_bus_idx = AudioServer.bus_count
	_audio_bus_name = "SpatialBus#"+str(_audio_bus_idx)
	AudioServer.add_bus(_audio_bus_idx)
	AudioServer.set_bus_name(_audio_bus_idx,_audio_bus_name)
	AudioServer.set_bus_send(_audio_bus_idx,bus)
	self.bus = _audio_bus_name
	
	#Add the effects to the custom audio bus
	AudioServer.add_bus_effect(_audio_bus_idx,AudioEffectReverb.new(),0)
	_reverb_effect = AudioServer.get_bus_effect(_audio_bus_idx,0)
	AudioServer.add_bus_effect(_audio_bus_idx,AudioEffectLowPassFilter.new(),1)
	_lowpass_filter = AudioServer.get_bus_effect(_audio_bus_idx,1)
	
	#Capture the target volume, we will start from no sound and lerp to where it should be
	_target_volume_db = volume_db
	volume_db = -60.0
	
	#Initialize the raycast max distances
	$RayCastDown.target_position = Vector3(0,-max_raycast_distance,0)
	$RayCastLeft.target_position = Vector3(max_raycast_distance,0,0)
	$RayCastRight.target_position = Vector3(-max_raycast_distance,0,0)
	$RayCastForward.target_position = Vector3(0,0,max_raycast_distance)
	$RayCastForwardLeft.target_position = Vector3(0,0,max_raycast_distance)
	$RayCastForwardRight.target_position = Vector3(0,0,max_raycast_distance)
	$RayCastBackwardRight.target_position = Vector3(0,0,-max_raycast_distance)
	$RayCastBackwardLeft.target_position = Vector3(0,0,-max_raycast_distance)
	$RayCastBackward.target_position = Vector3(0,0,-max_raycast_distance)
	$RayCastUp.target_position = Vector3(0,max_raycast_distance,0)
	
	#Will be easier to just work with the array of raycasts since direction shouldn't matter
	_raycast_array.append($RayCastDown)
	_raycast_array.append($RayCastLeft)
	_raycast_array.append($RayCastRight)
	_raycast_array.append($RayCastForward)
	_raycast_array.append($RayCastForwardLeft)
	_raycast_array.append($RayCastForwardRight)
	_raycast_array.append($RayCastBackwardRight)
	_raycast_array.append($RayCastBackwardLeft)
	_raycast_array.append($RayCastBackward)
	_raycast_array.append($RayCastUp)

func _physics_process(delta):
	_last_update_time += delta
	
	#Should we update the raycast distance values
	if _update_distances:
		_on_update_raycast_distance(_raycast_array[_current_raycast_index], _current_raycast_index)
		_current_raycast_index += 1
		if _current_raycast_index >= _distance_array.size():
			_current_raycast_index = 0
			_update_distances = false
	
	#Check if we should update the spatial sound values
	if _last_update_time > update_frequency_seconds:
		var player_camera = get_viewport().get_camera_3d() #This might change over time
		if player_camera != null:
			_on_update_spatial_audio(player_camera)
		_update_distances = true
		_last_update_time = 0.0
		print(player_camera.global_position)
	
	#lerp parameters for a smooth transition
	_lerp_parameters(delta)
	
func _lerp_parameters(delta):
	volume_db = lerp(volume_db,_target_volume_db,delta * lerp_speed_modifier)
	_lowpass_filter.cutoff_hz = lerp(_lowpass_filter.cutoff_hz,_target_lowpass_cutoff,delta * 5.0 * lerp_speed_modifier)
	_reverb_effect.wet = lerp(_reverb_effect.wet,_target_reverb_wetness * max_reverb_wetness,delta * 5.0 * lerp_speed_modifier)
	_reverb_effect.room_size = lerp(_reverb_effect.room_size,_target_reverb_room_size,delta * 5.0 * lerp_speed_modifier)
	pitch_scale = max(lerp(pitch_scale,Engine.time_scale,delta * 5.0 / Engine.time_scale),0.01 * lerp_speed_modifier)

func _on_update_raycast_distance(raycast : RayCast3D, raycast_index : int):
	raycast.force_raycast_update() 	#Does not require enabled to be true
	var collider = raycast.get_collider()
	if collider != null:
		_distance_array[raycast_index] = self.global_position.distance_to(raycast.get_collision_point())
	else:
		_distance_array[raycast_index] = -1
	raycast.enabled = false			#Don't let this raycast run all the time

func _on_update_spatial_audio(player : Node3D):
	_on_update_reverb(player)
	_on_update_lowpass_filter(player)

func _on_update_lowpass_filter(_player : Node3D):
	if _lowpass_filter  != null:
		var query = PhysicsRayQueryParameters3D.create(self.global_position,self.global_position + (_player.global_position - self.global_position).normalized() * max_raycast_distance, $RayCastForward.get_collision_mask())
		var space_state = get_world_3d().direct_space_state
		var result = space_state.intersect_ray(query)
		var lowpass_cutoff = 20000 #init to a value where nothing gets cutoff
		if !result.is_empty():
			var ray_distance = self.global_position.distance_to(result["position"])
			var distance_to_player = self.global_position.distance_to(_player.global_position)
			var wall_to_player_ratio = ray_distance / max(distance_to_player,0.001)
			if ray_distance < distance_to_player:
				lowpass_cutoff = wall_lowpass_cutoff_amount * wall_to_player_ratio
		_target_lowpass_cutoff = lowpass_cutoff
		
	
func _on_update_reverb(_player : Node3D):
	if _reverb_effect != null:
		#Find the reverb params
		var room_size = 0.0
		var wetness = 1.0
		for dist in _distance_array:
			if dist >= 0:
				#find the average room size based on the raycast distances that are valid
				room_size += (dist / max_raycast_distance) / (float(_distance_array.size()))
				room_size = min(room_size,1.0)
			else:
				#if a raycast did not hit anything we will reduce the reverb effect, almost no raycasts should hit when outdoors nowhere near buildings
				wetness -= 1.0 / float(_distance_array.size())
				wetness = max(wetness,0.0)
		_target_reverb_wetness = wetness
		_target_reverb_room_size = room_size
