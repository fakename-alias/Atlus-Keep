extends Resource
class_name Leveling

signal level_up(new_level:int)
signal xp_changed(xp:int, needed:int)

@export var level: int = 1
@export var xp: int = 0
@export var max_level: int = 10 #subject to change
@export var base_xp: int = 100
@export var curve_pow: float = 1.5 #xp needed = base_xp * level^curve_pow

func xp_needed(level_i: int = -1) -> int:
	if level_i < 0: level_i = level
	return int(round(base_xp * pow(level_i, curve_pow)))

func add_xp(amount: int) -> void:
	if amount <= 0 or level >= max_level: return
	xp += amount
	while xp > xp_needed() and level < max_level:
		xp -= xp_needed()
		level += 1
		emit_signal("level_up", level)
	emit_signal("xp_changed", xp, xp_needed())
