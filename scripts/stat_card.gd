extends Sprite3D

@export var stats: CharacterStats
func set_stats(stats: CharacterStats) -> void: stats = stats

@export var hp_bar_path:= "../HealthBarSprite"

var menu_shown := false # var to make sure the stat card is only shown once

@onready var hp_bar: Node = get_node_or_null(hp_bar_path)
@onready var collider := $Area3D

func _ready() -> void:
	collider.input_ray_pickable = true
	if hp_bar:
		hp_bar.visible = false

func show_stat_card() -> void:
	# Put the entity stat card here
	print("This is a " + stats.name)
	print("__________")

func show_stat_menu() -> void:
	# Put the entity menu here
	print(owner.name)
	print("HP: " + str(stats.get_max_hp()))
	print("Stamina: " + str(stats.get_max_stamina()))
	print("Mana: " + str(stats.get_max_mana()))
	print("STR: " + str(stats.get_effective_str()))
	print("DEX: " + str(stats.get_effective_dex()))
	print("CON: " + str(stats.get_effective_con()))
	print("INT: " + str(stats.get_effective_int()))
	print("LCK: " + str(stats.get_effective_lck()))
	print("__________")


func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if (!menu_shown):
		menu_shown = true
		show_stat_card()
	
	if (event is InputEventMouseButton):
		if ((event.button_index == MOUSE_BUTTON_LEFT) and (event.double_click)):
			show_stat_menu()
			#since stat_card is a universal script, get_parent() returns what unit we are interacting with
			var parent_unit = get_parent()
			#available_attacks is the helper function we declared in the units script to show available actions
			if parent_unit and "available_attacks" in parent_unit:
				print("--- Available Attacks for ", parent_unit.stats.name, "---")
				for atk in parent_unit.available_attacks:
					var kind_label = Attack.Kind.keys()[atk.kind]
					print("%s | Kind: %s | Power: %d | Range: %d" % [atk.name, kind_label, atk.power, atk.range_tiles])
			else:
				print("No available attacks found for this unit or invalid parent.")

func _on_area_3d_mouse_entered() -> void:
	menu_shown = false
	if hp_bar: hp_bar.visible = true
	print(stats.get_hp())


func _on_area_3d_mouse_exited() -> void:
	menu_shown = false
	if hp_bar: hp_bar.visible = false
