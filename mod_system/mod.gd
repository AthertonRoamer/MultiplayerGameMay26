class_name Mod
extends Resource

signal active_changed(m : Mod, b : bool)

@export var name : String = ""
var active : bool = true:
	set(b):
		active = b
		active_changed.emit(self, b)

@export_enum("gun", "tank") var type : String = "gun"
@export var texture : Texture2D = preload("res://icon.svg")
