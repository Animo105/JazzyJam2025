extends CanvasLayer

var TOAST : PackedScene

var toasts : Array[ToastData]
enum ToastPos {
	CENTER_UP,
	RIGHT_UP,
	CENTER_RIGHT,
	BOTTOM_RIGHT,
	BOTTOM_CENTER,
	BOTTOM_LEFT,
	CENTER_LEFT,
	LEFT_UP
}

class ToastData:
	var message : String
	var header : String
	var lifespan : float
	var position : ToastPos
	var node : Toast
	
	func _init( toast_message : String = "This is a message", toast_header : String = "This is a header", toast_lifespan : float = -1) -> void:
		message = toast_message
		header = toast_header
		lifespan = toast_lifespan
	
	func set_node():
		if node:
			node.message = message
			node.header = header
	
	func queue_free():
		if node:
			node.queue_free()
		self.call_deferred('free')

func _ready() -> void:
	layer = 5
	TOAST = load("res://Globals/Toasts/Toast.tscn")

func _process(delta: float) -> void:
	if toasts == []:
		return
	for toast in toasts:
		if toast.lifespan != -1:
			toast.lifespan -= delta
			if toast.lifespan <= 0:
				toast.queue_free()
				toasts.erase(toast)

func add_toast(toast : ToastData):
	toasts.append(toast)
	var toast_node = TOAST.instantiate()
	toast.node = toast_node
	toast.set_node()
	add_child(toast_node)
	toast_node.position = Vector2(500, 500)

func clear_toasts():
	for toast in toasts:
		toast.queue_free()
