extends Sprite3D

@export var stats: CharacterStats
func set_stats(stats: CharacterStats) -> void: stats = stats

var menu_shown := false # var to make sure the stat card is only shown once
@onready var collider := $Area3D

func _ready() -> void:
	collider.input_ray_pickable = true

func show_stat_card() -> void:
	# Put the entity stat card here
	print("This is a" + stats.name)
	print("__________")

func show_stat_menu() -> void:
	# Put the entity menu here
	print(owner.name)
	print("Species: Blue Slime")
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


func _on_area_3d_mouse_entered() -> void:
	menu_shown = false


func _on_area_3d_mouse_exited() -> void:
	menu_shown = false
