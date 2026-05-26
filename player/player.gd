class_name Player
extends CharacterBody2D

var player_name : String = "Player"
var id : int
@export var name_display : Label 

@export var gun : Node2D
@export var body : Node2D

@export var local : bool = false #this player node is running on the player who controls it
@export var active : bool = false

@export var speed : int = 250
var mod_manager : ModManager

@export var starting_energy : float = 0
@export var energy : float = starting_energy
@export var energy_increase_rate : float = 1 #energy per second
@export var energy_max : float = 10

@export var starting_health := 100
@export var health = starting_health:
	set(v):
		if v <= 0:
			health = 0
			die()
		else:
			health = v
			
@export var mod_item_scene : PackedScene

func _ready():
	name = str(id)
	
	local = id == multiplayer.get_unique_id()
	if not local:
		name_display.text = player_name
	Main.mode.lobby.member_left.connect(_on_member_left)
	mod_manager = ModManager.new()
	mod_manager.name = "ModManager"
	add_child(mod_manager)
	if local:
		$Camera2D.enabled = true
		
		
func _process(delta: float) -> void:
	energy += energy_increase_rate * delta
	energy = max(0, energy)
	energy = min(energy_max, energy)
	
func _physics_process(_delta) -> void:
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
		
		if vel.length() > 0:
			vel = vel.normalized()
			body.rotation = vel.angle() + deg_to_rad(90)
			
		velocity = vel * speed
		move_and_slide()
		
		if gun:
			gun.rotation = (get_global_mouse_position()- gun.global_position).angle() + deg_to_rad(90)
		
		update_position.rpc(position)
		update_rotation.rpc(gun.rotation, body.rotation)
		
@rpc("any_peer")
func update_position(new_position : Vector2) -> void:
	position = new_position
	
@rpc("any_peer")
func update_rotation(gun_rotation,body_rotation):
	gun.rotation = gun_rotation
	body.rotation = body_rotation
	
	
func _on_member_left(member : LobbyMember) -> void:
	if member.id == id:
		queue_free()
		
		
func pickup_mod(mod : Mod) -> void:
	mod.active = true
	mod_manager.add_mod(mod)
	
	
func drop_mod(mod : Mod) -> void:
	mod_manager.remove_mod(mod)
	var mod_item : ModItem = mod_item_scene.instantiate()
	mod_item.mod = mod
	mod_item.global_position = global_position
	Main.mode.get_world().get_node("ModItems").add_child(mod_item)
	
	
	
func _unhandled_input(event: InputEvent) -> void:
	if not local:
		return
	if event.is_action_pressed("fire") and not event.is_echo():
		trigger_fire.rpc()
		
	
@rpc("call_local", "reliable", "any_peer")
func trigger_fire() -> void:
	$ProjectileHandler.projectile_direction = Vector2.UP.rotated(gun.rotation)
	$ProjectileHandler.mod_name_list = mod_manager.get_active_mods_names()
	$ProjectileHandler.fire()
	
	
func die() -> void:
	if multiplayer.is_server():
		$NetworkUnloader.initiate_unload()
		
	
	
func take_damage(damage, _damage_type) -> void:
	health -= damage
		


func _on_network_unloader_cease_rpcs_request_received() -> void:
	active = false
	$NetworkUnloader.register_as_ceased()
