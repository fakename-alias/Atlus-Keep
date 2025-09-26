extends Item

class_name Armor

#off hand is here since shields can be placed in the slot
enum Slot { HELMET, BODY, OFF_HAND }

#these can be uniquely adjusted in teh .tres files
@export var slot: Slot = Slot.BODY
@export var phys_armor: float = 0.0
@export var magic_resist: float = 0.0
@export var evasion_bonus: float = 0.0
