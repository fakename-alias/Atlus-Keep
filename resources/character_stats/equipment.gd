extends Resource
class_name Equipment
#simple signals to mass declare equip and unequip of items
signal equipped(slot:StringName, item:Item)
signal unequipped(slot:StringName, item:Item)

@export var helmet: Armor
@export var body: Armor
@export var main_hand: Weapon
@export var off_hand: Item #could be shield or 2 handed weapon
@export var ring1: Jewelry
@export var ring2: Jewelry

#check if an item is two handed
func is_two_handed() -> bool:
	return main_hand != null and main_hand.two_handed

#helper function to check if inventory slot is taken
func can_equip(item: Item) -> bool:
	if item is Weapon:
		var w:= item as Weapon
		return (not w.two_handed) or off_hand == null
	elif item is Armor:
		var a:= item as Armor
		#check for shield
		if a.slot == Armor.Slot.OFF_HAND:
			return not is_two_handed()
		return true
	elif item is Jewelry:
		return true
	return false

#manual equipping
func equip(item: Item) -> bool:
	if not can_equip(item): 
		return false
	#check if item is a weapon
	if item is Weapon:
		var w:= item as Weapon
		#try to equip a two handed weapon
		if w.two_handed:
			main_hand = w
			if off_hand:
				var prev = off_hand; off_hand = null
				unequipped.emit(&"off_hand", prev)
			equipped.emit(&"main_hand", w)
			return true
		#equip a one handed weapon
		if main_hand == null:
			main_hand = w
			equipped.emit(&"main_hand", w)
			return true
		#if main hand is taken then put it in off hand
		if off_hand == null:
			off_hand = w
			equipped.emit(&"off_hand", w)
			return true
		return false
	#check if item is armor
	if item is Armor:
		var a:= item as Armor
		#run through what slot the item belongs to
		match a.slot:
			Armor.Slot.HELMET:
				var prev_helmet = helmet
				helmet = a
				if prev_helmet: 
					unequipped.emit(&"helmet", prev_helmet)
				equipped.emit(&"helmet", a)
				return true
			Armor.Slot.BODY:
				var prev_body = body
				body = a
				if prev_body:
					unequipped.emit(&"body", prev_body)
				equipped.emit(&"body", a)
				return true
			Armor.Slot.OFF_HAND:
				if is_two_handed():
					return false
				var prev_off_hand = off_hand
				off_hand = a
				if prev_off_hand:
					unequipped.emit(&"off_hand", prev_off_hand)
				equipped.emit(&"off_hand", a)
				return true
	#check if item is jewelry
	if item is Jewelry:
		if ring1 == null:
			ring1 = item as Jewelry
			equipped.emit(&"ring1", ring1)
			return true
		elif ring2 == null:
			ring2 = item as Jewelry
			equipped.emit(&"ring2", ring2)
			return true
		else:
			#simple swap, replace ring 2
			var prev = ring2
			ring2 = item as Jewelry
			unequipped.emit(&"ring2", prev)
			equipped.emit(&"ring2", ring2)
			return true
		
	return false

#manual unequipping
func unequip(slot:StringName) -> Item:
	match slot:
		&"helmet":
			var item = helmet
			helmet = null
			if item: unequipped.emit(slot, item)
			return item
		
		&"body":
			var item = body
			body = null
			if item: unequipped.emit(slot, item)
			return item
			
		&"main_hand":
			var item = main_hand
			main_hand = null
			if item: unequipped.emit(slot, item)
			return item
		&"off_hand":
			var item = off_hand
			off_hand = null
			if item: unequipped.emit(slot, item)
			return item
		&"ring1":
			var item = ring1
			ring1 = null
			if item: unequipped.emit(slot, item)
			return item
		&"ring2":
			var item = ring2
			ring2 = null
			if item: unequipped.emit(slot, item)
			return item
	return null

#grab total resistances to mitigate damage
#also grab weapon accuracy bonus
func total_phys_armor() -> float:
	var total:= 0.0
	if helmet: total += helmet.phys_armor
	if body: total += body.phys_armor
	if off_hand is Armor: total += off_hand.phys_armor
	return total

func total_magic_resist() -> float:
	var total:= 0.0
	if helmet: total += helmet.magic_resist
	if body: total += body.magic_resist
	if off_hand is Armor: total += off_hand.magic_resist
	return total

func total_evasion_bonus() -> float:
	var total:= 0.0
	if helmet: total += helmet.evasion_bonus
	if body: total += body.evasion_bonus
	if off_hand is Armor: total += off_hand.evasion_bonus
	return total

func total_accuracy_bonus() -> float:
	var total:= 0.0
	if main_hand: total += main_hand.accuracy_bonus
	if off_hand is Weapon: total += off_hand.accuracy_bonus
	return total

#Flat stat bonuses from rings (for now)
func bonus_str() -> int:
	var total:= 0
	if ring1: total +=ring1.strength_bonus
	if ring2: total += ring2.strength_bonus
	return total

func bonus_dex() -> int:
	var total:= 0
	if ring1: total +=ring1.dexterity_bonus
	if ring2: total += ring2.dexterity_bonus
	return total

func bonus_con() -> int:
	var total:= 0
	if ring1: total +=ring1.constitution_bonus
	if ring2: total += ring2.constitution_bonus
	return total

func bonus_int_stat() -> int:
	var total:= 0
	if ring1: total +=ring1.intelligence_bonus
	if ring2: total += ring2.intelligence_bonus
	return total

func bonus_lck() -> int:
	var total:= 0
	if ring1: total +=ring1.luck_bonus
	if ring2: total += ring2.luck_bonus
	return total

func get_main_weapon() -> Weapon:
	return main_hand as Weapon

func get_off_hand_weapon() -> Weapon:
	return off_hand as Weapon

func get_equipped_attacks(base_attacks: Array[Attack]) -> Array[Attack]:
	var output: Array[Attack] = []
	if base_attacks: out.apend_array(base_attack)
