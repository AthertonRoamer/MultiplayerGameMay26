class_name EnergyDisplay
extends HBoxContainer

var local_player : Player


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if is_instance_valid(local_player):
		$TextureProgressBar.value = local_player.energy
		$Label.text = str(floor(local_player.energy *10) / 10)


func _on_world_game_loaded(l_player: Player) -> void:
	local_player = l_player
	$TextureProgressBar.max_value = local_player.energy_max
	
