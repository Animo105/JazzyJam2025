extends PlayerState
class_name PlayerSlideState
@onready var camera: Camera3D = $"../../neck/camera"
@onready var crouch_collision_shape: CollisionShape3D = $"../../crouchCollisionShape"
@onready var regular_collision_shape: CollisionShape3D = $"../../regularCollisionShape"

const ACCELERATION = 20
const DECELERATION = 17
var dir : Vector3

func enter():
	dir = player.last_direction
	player.velocity = dir * ACCELERATION
	player.set_crouch(true)

func exit():
	player.set_crouch(false)

func physics_update(delta:float):
	player.apply_gravity(delta)
	player.velocity.x = move_toward(player.velocity.x, 0, DECELERATION * delta)
	player.velocity.z = move_toward(player.velocity.z, 0, DECELERATION * delta)
	if Input.is_action_just_released("slide"):
		fsm.change_state('crouch')
