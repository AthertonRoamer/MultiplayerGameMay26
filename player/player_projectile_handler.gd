class_name PlayerProjectileHandler
extends ProjectileHandler

var mod_name_list : Array[String]

func set_up_projectile() -> Projectile:
	var p := super()
	p.wielder = get_parent()
	return p
