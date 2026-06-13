class_name PlayerProjectileHandler
extends ProjectileHandler

@export var default_energy_cost : float = 1
var energy_cost : float = default_energy_cost

func set_up_projectile() -> Projectile:
	var p := super()
	p.wielder = get_parent()
	return p
	
	
func fire_projectile() -> void:
	super()
	get_parent().energy -= energy_cost
	
	
func can_fire() -> bool:
	return super() and get_parent().energy > energy_cost
