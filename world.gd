class_name World
extends Node2D

signal game_loaded(local_player : Player)

var players : Array[Player] = []
var first_pos : Vector2 = Vector2(100, 100)
@export var player_scene : PackedScene 
var local_player : Player

func _ready() -> void:
	if get_parent() is GameManager:
		for member in get_parent().lobby.members:
			load_player(member)
		if get_parent().lobby.is_master:
			visible = false
			$"CanvasLayer/Quit Game".visible = false
		for p in players:
			if p.local:
				local_player = p
		game_loaded.emit(local_player)
				
				
func start() -> void:
	set_players_active(true)
		
		
func set_players_active(active : bool) -> void:
	for player in players:
		if is_instance_valid(player):
			player.active = active


func end() -> void:
	$NetworkUnloader.initiate_unload()
	
	
func load_player(member : LobbyMember) -> void:
	var new_player : Player = player_scene.instantiate()
	players.append(new_player)
	new_player.id = member.id
	new_player.player_name = member.name
	new_player.position = Vector2(first_pos.x + 100 * (players.size() - 1), first_pos.y)
	add_child(new_player)


func _on_network_unloader_cease_rpcs_request_received() -> void:
	set_players_active(false)
	($NetworkUnloader as NetworkUnloader).register_as_ceased()


func _on_quit_game_pressed() -> void:
	if get_parent().lobby.has_authority:
		get_parent().lobby.trigger_request_end_game()
	else:
		Main.mode.leave_lobby()
