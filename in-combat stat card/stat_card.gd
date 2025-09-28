extends Sprite3D

var menu_shown := false # var to make sure the stat card is only shown once

@onready var collider := $Area3D

func _ready() -> void:
	collider.input_ray_pickable = true

# Whenever the mouse moves to the sprite's location
func _on_input_event(camera: Camera3D, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int):
	# If hovered, show a quick stat card (could be Stamina, Mana, available skills, etc...)
	if (!menu_shown):
		menu_shown = true
		show_stat_card()
		
	# If double clicked, show the fullscreen entity menu thingy (Change if necessary)
	if (event is InputEventMouseButton):
		if ((event.button_index == MOUSE_BUTTON_LEFT) and (event.double_click)):
			show_stat_menu()
	
	
func _on_mouse_entered():
	menu_shown = false
	
func _on_mouse_exited():
	menu_shown = false
	
func show_stat_card() -> void:
	# Put the entity stat card here
	print("This is " + owner.name)
	print("__________")

func show_stat_menu() -> void:
	# Put the entity menu here
	print(owner.name)
	print("Species: Blue Slime")
	print("STR: " + str(randi() & 10))
	print("DEX: " + str(randi() & 10))
	print("CON: " + str(randi() & 10))
	print("INT: " + str(randi() & 10))
	print("LCK: " + str(randi() & 10))
	print("__________")
