extends PlayerState
class_name PlayerSlideState
@onready var camera: Camera3D = $"../../neck/camera"
@onready var crouch_collision_shape: CollisionShape3D = $"../../crouchCollisionShape"
@onready var regular_collision_shape: CollisionShape3D = $"../../regularCollisionShape"

const ACCELERATION = 15
const DECELERATION = 9
var dir : Vector3
var basic_camera_pos : Vector3

func enter():
	crouch_collision_shape.disabled = false
	regular_collision_shape.disabled = true
	dir = player.last_direction
	player.velocity = dir * ACCELERATION
	var tween :Tween = create_tween()
	basic_camera_pos = camera.position
	tween.tween_property(camera, "position", Vector3(basic_camera_pos.x, basic_camera_pos.y - 1.5, basic_camera_pos.z), 0.1)

func exit():
	regular_collision_shape.disabled = false
	crouch_collision_shape.disabled = true
	var tween :Tween = create_tween()
	tween.tween_property(camera, "position", basic_camera_pos, 0.1)

func physics_update(delta:float):
	player.apply_gravity(delta)
	player.velocity.x = move_toward(player.velocity.x, 0, DECELERATION * delta)
	player.velocity.z = move_toward(player.velocity.z, 0, DECELERATION * delta)
	if Input.is_action_just_released('slide'):
		fsm.change_state('ground')
