extends Node3D

@onready var nav_agent: NavigationAgent3D = $NavigationAgent
@onready var ray_cast: RayCast3D = $RayCast
@onready var chase_timer: Timer = $ChaseTimer
@onready var animation_player: AnimationPlayer = $JazzyTonic/AnimationPlayer

enum State { PATROL, CHASE }

@export var player: Player
@export var patrol_points: Array[Marker3D]
@export var patrol_speed: float = 1.5
@export var chase_speed: float = 4.0
@export var fov_deg: float = 120.0
@export var nearby_radius: float = 4.0
@export var ray_cast_sample: int = 5
@export var turning_speed: float = 8

var patrol_index := 0
var state := State.PATROL
var speed := patrol_speed
var hit_height : float

func _ready():
	if patrol_points.size() > 0:
		nav_agent.target_position = patrol_points[0].global_position
	animation_player.play("Walk")
	Global.is_hiding.connect(_stop_patrol)

func _stop_patrol():
	if state == State.CHASE:
		enter_patrol_state()

func _physics_process(delta):
	match state:

		State.PATROL:
			patrol_behavior()
			if !player.is_hiding && detect_player():
				enter_chase_state()
		State.CHASE:
			chase_behavior()
			if detect_player():
				chase_timer.start()
			elif chase_timer.time_left <= 0.0:
				enter_patrol_state()

	var next_pos := nav_agent.get_next_path_position()
	global_position = global_position.move_toward(next_pos, speed * delta)
	
	var direction = (next_pos - global_position).normalized()
	var target_yaw = atan2(direction.x, direction.z) + PI
	global_rotation.y = lerp_angle(global_rotation.y, target_yaw, clamp(turning_speed * delta, 0, 1))


func enter_chase_state() -> void:
	state = State.CHASE
	speed = chase_speed
	chase_timer.start()
	animation_player.speed_scale = 4


func enter_patrol_state() -> void:
	state = State.PATROL
	speed = patrol_speed
	nav_agent.target_position = patrol_points[patrol_index].global_position
	animation_player.speed_scale = 2


func patrol_behavior() -> void:
	if nav_agent.is_navigation_finished():
		patrol_index = (patrol_index + 1) % patrol_points.size()
		nav_agent.target_position = patrol_points[patrol_index].global_position


func chase_behavior() -> void:
	if player.is_hiding:
		return
	nav_agent.target_position = player.global_position


func detect_player() -> bool:
	var can_see = line_of_sight()
	return can_see and (player_in_fov() or player_is_close())


func player_is_close() -> bool:
	return global_position.distance_to(player.global_position + Vector3( 0, hit_height, 0)) <= nearby_radius


func player_in_fov() -> bool:
	var forward = -global_transform.basis.z.normalized()
	var to_player = (player.global_position - global_position + Vector3( 0, hit_height, 0)).normalized()

	var dot_val = forward.dot(to_player)
	var cutoff = cos(deg_to_rad(fov_deg * 0.5))

	return dot_val >= cutoff


func line_of_sight() -> float:
	var sample_step = player.get_height() / ray_cast_sample
	for i in range(ray_cast_sample):
		var height = sample_step * i
		ray_cast.target_position = ray_cast.to_local(player.global_position + Vector3( 0, height, 0))
		ray_cast.force_raycast_update()

		if ray_cast.get_collider() == player:
			hit_height = height
			return true

	return false
	

func _on_kill_zone_body_entered(_body: Node3D) -> void:
	if player.is_hiding:
		return
	get_tree().change_scene_to_file("res://ennemi/killScene.tscn")
