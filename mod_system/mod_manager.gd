class_name ModManager
extends RefCounted

signal mod_active_changed(m : Mod, b : bool)

var mods : Array[Mod] = []:
	get():
		mods = tank_mods.duplicate()
		mods.append_array(gun_mods)
		return mods
		
var max_tank_mods : int = 3
var max_gun_mods : int = 4
var tank_mods : Array[Mod] = []
var gun_mods : Array[Mod] = []

func get_mods() -> Array[Mod]:
	return mods
	
	
func get_active_mods() -> Array[Mod]:
	return mods.filter(func (x) : return x.active)
	
	
func get_unactive_mods() -> Array[Mod]:
	return mods.filter(func(x) : return not x.active)
	
	
func add_mod(mod : Mod) -> bool:
	match mod.type:
		"gun":
			if gun_mods.size() < max_gun_mods:
				gun_mods.append(mod)
				mod.active_changed.connect(_on_mod_active_changed)
				return true
			else:
				return false
		"tank":
			if tank_mods.size() < max_tank_mods:
				tank_mods.append(mod)
				mod.active_changed.connect(_on_mod_active_changed)
				return true
			else:
				return false
		_:
			push_warning("Trying to add invalid mod type")
			return false
			
			
func remove_mod(mod):
	var mod_array : Array[Mod]
	match mod.type:
		"gun":
			mod_array = gun_mods
		"tank":
			mod_array = tank_mods
	var mod_to_delete : Mod = null
	for m in mod_array:
		if m.name == mod.name:
			mod_to_delete = m 
	if mod_to_delete != null:
		mod_array.erase(mod_to_delete)
		
		
func _on_mod_active_changed(m : Mod, b : bool) -> void:
	mod_active_changed.emit(m, b)
	
	
func get_active_mod_count(mod_name : String) -> bool:
	var count : int = 0
	for m in get_active_mods():
		if m.name == mod_name:
			count += 1
	return count
		
	
	
	
