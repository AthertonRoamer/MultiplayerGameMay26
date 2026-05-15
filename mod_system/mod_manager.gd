class_name ModManager
extends Node

@export var available_mods : Array[Mod]

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
	
	
func get_active_mods_names() -> Array[String]:
	var active_mods := get_active_mods()
	var results : Array[String]
	for m in active_mods:
		results.append(m.name)
	return results
	
	
func get_unactive_mods() -> Array[Mod]:
	return mods.filter(func(x) : return not x.active)
	

@rpc("any_peer", "reliable")
func trigger_add_mod(mod_name : String) -> void:
	add_mod(mod_name)

func add_mod(mod) -> bool:
	if mod is String:
		return add_mod(get_mod_from_name(mod))
	elif mod is Mod:
		match mod.type:
			"gun":
				if gun_mods.size() < max_gun_mods:
					var m = mod.duplicate()
					gun_mods.append(m)
					m.active_changed.connect(_on_mod_active_changed)
					if get_parent().local:
						trigger_add_mod.rpc(m.name)
					return true
				else:
					return false
			"tank":
				if tank_mods.size() < max_tank_mods:
					var m = mod.duplicate()
					tank_mods.append(m)
					m.active_changed.connect(_on_mod_active_changed)
					if get_parent().local:
						trigger_add_mod.rpc(m.name)
					return true
				else:
					return false
			_:
				push_warning("Trying to add invalid mod type")
				return false
	else:
		return false
		
		
func get_mod_from_name(mod_name : String) -> Mod:
	var result : Mod = null
	for mod in available_mods:
		if mod.name == mod_name:
			result = mod
	return result
	
	
@rpc("any_peer", "reliable")
func trigger_remove_mod(mod_name : String) -> void:
	remove_mod(mod_name)
	
	
func remove_mod(mod):
	if mod is String:
		remove_mod(get_mod_from_name(mod))
	elif mod is Mod:
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
			if get_parent().local:
				trigger_remove_mod.rpc(mod_to_delete.name)
		
		
func _on_mod_active_changed(m : Mod, b : bool) -> void:
	mod_active_changed.emit(m, b)
	
	
func get_active_mod_count(mod_name : String) -> bool:
	var count : int = 0
	for m in get_active_mods():
		if m.name == mod_name:
			count += 1
	return count
		
	
	
	
