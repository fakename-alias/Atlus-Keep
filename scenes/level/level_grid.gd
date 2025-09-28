extends Node3D

@onready var grid:GridMap = $GridMap
@onready var doo:MeshInstance3D = $DingDong
@onready var camera:Camera3D = $Camera3D

func _ready():
	print(grid.get_used_cells())
	doo.position = Vector3(grid.position.x, 3, grid.position.z)

func _input(event):
	if event.is_action_pressed("select"):
		
		
		
		print("Shmooved")
	
	if event.is_action("up"):
		camera.rotation += Vector3(.1,0,0)
	if event.is_action("down"):
		camera.rotation -= Vector3(.1,0,0)
	if event.is_action("left"):
		camera.rotation += Vector3(0,.1,0)
	if event.is_action("right"):
		camera.rotation -= Vector3(0,.1,0)
	

func world_to_cell(world_pos: Vector3):
	var local: Vector3 = grid.map_to_local(world_pos)
	return grid.local_to_map(local)
