extends Item

class_name Weapon
#possibly add more types later
enum WeaponType { MELEE, RANGED, MAGIC }

#base values to be balanced, these can be changed to fit the item type in its tres file
@export var type: WeaponType = WeaponType.MELEE
@export var base_damage: float = 10.0
@export var stamina_cost: int = 5
@export var mana_cost: int = 0
@export var accuracy_bonus: float = 0.0
@export var range_tiles: int = 1
@export var two_handed: bool = false
