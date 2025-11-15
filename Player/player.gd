extends CharacterBody3D
class_name Player

@onready var neck: Node3D = $neck
@onready var camera: Camera3D = $neck/camera
@onready var regular_collision_shape: CollisionShape3D = $regularCollisionShape
@onready var crouch_collision_shape: CollisionShape3D = $crouchCollisionShape

const DEFAUT_CAM_POS : Vector3 = Vector3(0, 1.2, 0)
const CROUCH_CAM_POS : Vector3 = Vector3(0, 0.4, 0)

const JUMP_VELOCITY = 5.5

var tween : Tween

func set_crouch(enable : bool):
	print("set crouch", enable)
	if (enable):
		crouch_collision_shape.disabled = false
		regular_collision_shape.disabled = true
		if tween:
			tween.kill()
		tween = create_tween()
		tween.tween_property(camera, "position", CROUCH_CAM_POS, 0.1)
		
	else:
		crouch_collision_shape.disabled = true
		regular_collision_shape.disabled = false
		if tween:
			tween.kill()
		tween = create_tween()
		tween.tween_property(camera, "position", DEFAUT_CAM_POS, 0.1)


@onready var fsm: PlayerFSM = $PlayerFSM

var last_direction : Vector3

func _physics_process(delta: float) -> void:
	fsm.physics_update(delta)
	move_and_slide()

func jump()->void:
	velocity.y = JUMP_VELOCITY

func move_player(speed : float, acceleration : float, deceleration : float)->void:
	var input_dir := Input.get_vector("left", "right", "forward", "back")
	var direction := (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
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
		neck.rotate_y(deg_to_rad(-event.relative.x * Global.mouse_sensitivity)) # rotate sur y axis le personnage (left/right)
		camera.rotate_x(deg_to_rad(-event.relative.y * Global.mouse_sensitivity)) # rotate sur x axis la camera (up/down)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-70), deg_to_rad(70)) # clamp la rotation

func apply_gravity(delta : float)->void:
	velocity += get_gravity() * delta
