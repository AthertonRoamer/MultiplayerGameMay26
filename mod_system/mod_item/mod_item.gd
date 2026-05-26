class_name ModItem
extends Area2D

@export var mod: Mod
@export var pickup_action: StringName = &"interact"

@export var normal_modulate: Color = Color.WHITE
@export var highlight_modulate: Color = Color(1.4, 1.4, 1.4)

@onready var sprite: Sprite2D = $Sprite2D

var _picked_up := false


func _ready() -> void:
	if mod != null:
		sprite.texture = mod.texture
	
	body_entered.connect(_update_highlight)
	body_exited.connect(_update_highlight)
	
	sprite.modulate = normal_modulate
	_update_highlight(null)

func _process(_delta: float) -> void:
	if _picked_up:
		return
	
	var local_player := _get_local_overlapping_player()
	
	if local_player == null:
		return
	
	if Input.is_action_just_pressed(pickup_action):
		if local_player.has_method("pickup_mod"):
			local_player.pickup_mod(mod)
			
			_picked_up = true
			rpc("destroy_pickup")


func _update_highlight(_body) -> void:
	if _picked_up:
		sprite.modulate = normal_modulate
		return
	
	if _get_overlapping_players().is_empty():
		sprite.modulate = normal_modulate
	else:
		sprite.modulate = highlight_modulate


func _get_overlapping_players() -> Array[Node]:
	var players: Array[Node] = []
	
	for body in get_overlapping_bodies():
		if body.is_in_group("player"):
			players.append(body)
	
	return players


func _get_local_overlapping_player() -> Node:
	for player in _get_overlapping_players():
		if player.local:
			return player
	return null


@rpc("call_local", "reliable", "any_peer")
func destroy_pickup() -> void:
	queue_free()
