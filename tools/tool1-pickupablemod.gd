@tool
extends EditorScript

func _run() -> void:
	# Get the currently edited scene root
	var root := get_editor_interface().get_edited_scene_root()
	if root == null:
		push_error("No edited scene root found.")
		return
	
	# Create Area2D
	var area := Area2D.new()
	area.name = "Area2D"
	
	# Create Sprite2D
	var sprite := Sprite2D.new()
	sprite.name = "Sprite2D"
	
	# Create CollisionShape2D
	var collision := CollisionShape2D.new()
	collision.name = "CollisionShape2D"
	
	# Create circle shape
	var circle := CircleShape2D.new()
	circle.radius = 32.0
	collision.shape = circle
	
	# Build hierarchy
	area.add_child(sprite)
	area.add_child(collision)
	root.add_child(area)
	
	# Set owners so nodes appear in the editor scene tree
	area.owner = root
	sprite.owner = root
	collision.owner = root
	
	print("Added Area2D with Sprite2D and CircleShape2D to scene root.")
