extends Node3D

@export var stats: CharacterStats
@export var equipment: Equipment

@onready var card:= $Sprite3D
@onready var bar: ProgressBar = $HealthBarViewport/HealthBarUI/Bar

#--- Attack Integration ---
@export var base_attacks: Array[Attack] = [] #unarmed/innate attacks
var available_attacks: Array[Attack] = [] #base and equipment attacks

func _ready():
	if equipment:
		if not equipment.resource_local_to_scene:
			equipment = equipment.duplicate(true)
			equipment.resource_local_to_scene = true
		# attach equipment to stats BEFORE pools are initialized
		stats.equipment = equipment
	
	if stats: stats.init_current_pools()
	
	if bar: 
		stats.hp_changed.connect(_on_hp_changed)
		_on_hp_changed(stats.get_hp(), stats.get_max_hp())
		
	if card and card.has_method("set_stats"):
		card.set_stats(stats)
	
	# listen for equip/unequip to refresh derived things
	if equipment:
		equipment.equipped.connect(_on_equipment_changed)
		equipment.unequipped.connect(_on_equipment_changed)
	
	_refresh_available_attacks() #grab available actions on spawn

func _process(delta: float) -> void:
	if stats:
		bar.max_value = stats.get_max_hp()
		bar.value = stats.hp

func _on_hp_changed(current: int, max_value: int) -> void:
	if bar:
		bar.min_value = 0
		bar.max_value = max_value
		bar.value = current

func _on_equipment_changed(_slot: StringName, _item: Item) -> void:
	#tweak this to match desired hp fixing
	stats.set_hp(min(stats.get_hp(), stats.get_max_hp()))
	_refresh_available_attacks()

func _refresh_available_attacks() -> void:
	if stats and stats.equipment:
		available_attacks = stats.equipment.get_equipped_attacks(base_attacks)
	else:
		available_attacks = base_attacks.duplicate()

# --- simple equip and unequip logic
func try_equip(item: Item) -> bool:
	if not stats or not stats.equipment: return false
	return stats.equipment.equip(item)

func try_unequip(slot: StringName) -> Item:
	if not stats or not stats.equipment: return null
	return stats.equipment.unequip(slot)

func use_attack(atk: Attack, target_node: Node) -> bool:
	if not stats or not atk:
		return false

	# Pick target stats (self if none)
	var tgt: CharacterStats = stats
	if target_node and "stats" in target_node and target_node.stats:
		tgt = target_node.stats

	match atk.kind:
		Attack.Kind.HEAL:
			tgt.heal(int(round(atk.power)))
			return true
		Attack.Kind.PHYS:
			# optional: pass atk.power/accuracy_bonus into your stats method if you add params
			stats.physical_attack(tgt)
			return true
		Attack.Kind.RANGED:
			stats.ranged_attack(tgt)
			return true
		Attack.Kind.MAGIC:
			stats.magic_attack(tgt)
			return true
	return false
