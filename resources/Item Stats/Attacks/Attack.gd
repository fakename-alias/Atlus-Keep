extends Resource

class_name Attack

@export var name: String = "unnamed"
@export var power: int = 0
@export var stamina_cost: int = 0
@export var mana_cost: int = 0
@export var range_tiles: int = 0
@export var tags: Array[String] = []
@export var effect: AttackEffect	#optional special behavior

#apply any effect the attack might have
func perform(user, target) -> void:
	if effect:
		effect.apply(user, target, self)
