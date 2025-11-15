extends CharacterBody3D
class_name Player

@onready var neck: Node3D = $neck
@onready var camera: Camera3D = $neck/camera
@onready var regular_collision_shape: CollisionShape3D = $regularCollisionShape
@onready var crouch_collision_shape: CollisionShape3D = $crouchCollisionShape
@onready var detection: Area3D = $Detection
@onready var camera_effects: CameraEffetcs = $neck/camera/CameraCanvas

const DEFAUT_CAM_POS : Vector3 = Vector3(0, 1.2, 0)
const CROUCH_CAM_POS : Vector3 = Vector3(0, 0.4, 0)

const JUMP_VELOCITY = 6

var basic_fov = 75
var is_hiding : bool = false
var pos_tween : Tween
var fov_tween : Tween

func set_crouch(enable : bool):
	if (enable):
		crouch_collision_shape.disabled = false
		regular_collision_shape.disabled = true
		if pos_tween:
			pos_tween.kill()
		pos_tween = create_tween()
		pos_tween.tween_property(camera, "position", CROUCH_CAM_POS, 0.1)
		
	else:
		crouch_collision_shape.disabled = true
		regular_collision_shape.disabled = false
		if pos_tween:
			pos_tween.kill()
		pos_tween = create_tween()
		pos_tween.tween_property(camera, "position", DEFAUT_CAM_POS, 0.1)

@onready var fsm: PlayerFSM = $PlayerFSM

func get_height()->float:
	if regular_collision_shape.disabled:
		return 2.0
	else:
		return 3.0

func _ready() -> void:
	camera.fov = basic_fov

var last_direction : Vector3

func _process(delta: float) -> void:
	fsm.update(delta)

func _physics_process(delta: float) -> void:
	if fov_tween:
		fov_tween.kill()
	fov_tween = create_tween()
	fov_tween.tween_property(camera, 'fov', get_greater_velocity()+basic_fov, 0.1)
	fsm.physics_update(delta)
	move_and_slide()

func get_greater_velocity()->float:
	return max(abs(velocity.x), abs(velocity.z))

func jump()->void:
	velocity.y = JUMP_VELOCITY

func move_player(speed : float, acceleration : float, deceleration : float)->void:
	var input_dir := Input.get_vector("left", "right", "forward", "back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = move_toward(velocity.x, direction.x * speed, acceleration)
		velocity.z = move_toward(velocity.z, direction.z * speed, acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration)
		velocity.z = move_toward(velocity.z, 0, deceleration)
	last_direction = direction

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if event is InputEventMouseButton:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if event is InputEventMouseMotion:
		if not Input.mouse_mode == Input.MOUSE_MODE_CAPTURED: return # si mouse pas capture, empêche de bouger
		rotate_y(deg_to_rad(-event.relative.x * Global.mouse_sensitivity)) # rotate sur y axis le personnage (left/right)
		camera.rotate_x(deg_to_rad(-event.relative.y * Global.mouse_sensitivity)) # rotate sur x axis la camera (up/down)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-70), deg_to_rad(70)) # clamp la rotation

func apply_gravity(delta : float)->void:
	velocity += get_gravity() * delta
