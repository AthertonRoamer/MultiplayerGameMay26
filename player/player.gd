class_name Player
extends CharacterBody2D

var player_name : String = "Player"
var id : int
@export var name_display : Label 

@export var local : bool = false #this player node is running on the player who controls it
@export var active : bool = false

@export var speed : int = 250
var mod_manager : ModManager

func _ready():
	name = str(id)
	
	local = id == multiplayer.get_unique_id()
	if not local:
		name_display.text = player_name
	Main.mode.lobby.member_left.connect(_on_member_left)
	mod_manager = ModManager.new()
	
	
func _physics_process(delta) -> void:
	if active and local:
		var vel : Vector2 = Vector2.ZERO
		if Input.is_action_pressed("player_up"):
			vel.y -= 1
		if Input.is_action_pressed("player_down"):
			vel.y += 1
		if Input.is_action_pressed("player_left"):
			vel.x -= 1
		if Input.is_action_pressed("player_right"):
			vel.x += 1
		
		vel = vel.normalized()
		velocity = vel * speed
		move_and_slide()
		update_position.rpc(position)
		
		
@rpc("any_peer")
func update_position(new_position : Vector2) -> void:
	position = new_position
	
	
func _on_member_left(member : LobbyMember) -> void:
	if member.id == id:
		queue_free()
		
		
func pickup_mod(mod : Mod) -> void:
	mod_manager.add_mod(mod)
