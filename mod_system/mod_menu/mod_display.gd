class_name ModDisplay
extends Control

@export var inactive_modulate : Color = Color(.5, .5, .5)
@export var active_modulate : Color = Color(1, 1, 1)
var mod : Mod
var local_player : Player

func _ready() -> void:
	$Button.icon = mod.menu_texture
	$Label.text = mod.name.capitalize()
	mod.active_changed.connect(_on_mod_active_changed)
	_on_mod_active_changed(null, mod.active)
	$Button.tooltip_text = mod.description
	
	
func _on_mod_active_changed(_m : Mod, active : bool) -> void:
	if active:
		modulate = active_modulate
	else:
		modulate = inactive_modulate


func _on_button_pressed_left_click() -> void:
	mod.active= not mod.active
	$Button.accept_event()


func _on_button_pressed_right_click() -> void:
	local_player.drop_mod(mod)
