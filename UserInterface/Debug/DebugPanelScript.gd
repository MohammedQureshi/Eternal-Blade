extends PanelContainer

@onready var property_container = %VBoxContainer

var frames_per_second: String

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	DebugManager.debug = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if visible:
		frames_per_second = "%.2f" % (1.0/delta)
	
func _input(event):
	if event.is_action_pressed("Debug"):
		visible = !visible
	
func add_property(title: String, value, order):
	var target
	target = property_container.find_child(title, true, false)
	if not target:
		target = Label.new()
		property_container.add_child(target)
		target.name = title
		target.text = target.name + ": " + str(value)
	elif visible:
		target.text = title + ": " + str(value)
		property_container.move_child(target, order)
