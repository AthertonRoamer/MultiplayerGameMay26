class_name ModMenu
extends HBoxContainer

var local_player : Player
@export var tank_mod_holder : Control
@export var gun_mod_holder : Control
@export var mod_display_scene : PackedScene

func _on_world_game_loaded(l_player: Player) -> void:
	set_up_local_player(l_player)
	
	
func set_up_local_player(l_player : Player) -> void:
	local_player = l_player
	local_player.mod_manager.mod_added.connect(_on_mod_added)
	local_player.mod_manager.mod_removed.connect(_on_mod_removed)
	
	
func load_mod_displays() -> void:
	for mod in local_player.mod_manager.get_mods():
		add_mod(mod)
	
	
func add_mod(mod : Mod) -> void:
	var holder = tank_mod_holder if mod.type == "tank" else gun_mod_holder
	var mod_display : ModDisplay = mod_display_scene.instantiate()
	mod_display.mod = mod
	mod_display.local_player = local_player
	holder.add_child(mod_display)
	
	
func clear_mod_displays() -> void:
	for child in tank_mod_holder.get_children():
		child.queue_free()
	for child in gun_mod_holder.get_children():
		child.queue_free()


func _on_mod_added(_mod : Mod) -> void:
	clear_mod_displays()
	load_mod_displays()
	
	
func _on_mod_removed(_mod : Mod) -> void:
	clear_mod_displays()
	load_mod_displays()
