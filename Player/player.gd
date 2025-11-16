extends CharacterBody3D
class_name Player

@onready var neck: Node3D = $neck
@onready var camera: Camera3D = $neck/camera
@onready var regular_collision_shape: CollisionShape3D = $regularCollisionShape
@onready var crouch_collision_shape: CollisionShape3D = $crouchCollisionShape
@onready var detection: Area3D = $Detection
@onready var camera_effects: CameraEffetcs = $neck/camera/CameraCanvas
@onready var steps: AudioStreamPlayer = $steps
@onready var fsm: PlayerFSM = $PlayerFSM
@onready var range: RayCast3D = $neck/camera/range
@onready var head_ray: RayCast3D = $headRay

const DEFAUT_CAM_POS : Vector3 = Vector3(0, 0.9, 0)
const CROUCH_CAM_POS : Vector3 = Vector3(0, 0.4, 0)

const DEFAULT_SPEED : float = 2
const DEFAULT_ACCELERATION : float = 3.0
const DEFAULT_DECELERATION : float = 4.0

const JUMP_VELOCITY = 4

var basic_fov = 75
var is_hiding : bool = false
var pos_tween : Tween
var fov_tween : Tween

var last_direction : Vector3



func _ready() -> void:
	camera.fov = basic_fov
	camera.position = DEFAUT_CAM_POS
	set_crouch(false)

func _physics_process(delta: float) -> void:
	check_range()

	if fov_tween:
		fov_tween.kill()
	fov_tween = create_tween()
	fov_tween.tween_property(camera, 'fov', get_greater_velocity()+basic_fov, 0.1)
	fsm.physics_update(delta)
	move_and_slide()

func is_moving()->bool:
	return not velocity.x == 0 && not velocity.z == 0

func play_step_sound():
	steps.pitch_scale = randf() * 0.2 + 0.9
	steps.play()

func _on_timeout():
	if Stamina.stamina > 0:
		Power.recharging.emit(true)
		Stamina.stamina -= 1

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

func get_height()->float:
	if regular_collision_shape.disabled:
		return 0.5
	else:
		return 1.0

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

func check_range():
	if range.is_colliding() && range.get_collider() is plush:
		Global.lookingAtPlush.emit()
		if Input.is_action_just_pressed("interract"):
			Global.plushCollected.emit(range.get_collider().id)
			Global.nbPlushCollected += 1
			print("you collected : ", Global.nbPlushCollected)

func update_velocity():
	velocity.x = move_toward(velocity.x, 0, DEFAULT_DECELERATION)
	velocity.z = move_toward(velocity.z, 0, DEFAULT_DECELERATION)
