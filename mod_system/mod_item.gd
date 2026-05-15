class_name ModItem
extends Area2D

@export var mod: Mod
@export var pickup_action: StringName = &"interact"

@export var normal_modulate: Color = Color.WHITE
@export var highlight_modulate: Color = Color(1.4, 1.4, 1.4)

@onready var sprite: Sprite2D = $Sprite2D

var _player_overlapping: Node = null


func _ready() -> void:
	sprite.texture = mod.texture
	
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	sprite.modulate = normal_modulate


func _process(_delta: float) -> void:
	if _player_overlapping == null:
		return
	
	if Input.is_action_just_pressed(pickup_action):
		if _player_overlapping.has_method("pickup_mod"):
			_player_overlapping.pickup_mod(mod)
			queue_free()


func _on_body_entered(body: Node) -> void:
	if not body.is_in_group("player"):
		return
	
	_player_overlapping = body
	sprite.modulate = highlight_modulate


func _on_body_exited(body: Node) -> void:
	if body != _player_overlapping:
		return
	
	_player_overlapping = null
	sprite.modulate = normal_modulate
