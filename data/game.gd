extends Node3D

@onready var level: Node3D = $LevelNotgrid
@onready var levelTileMaster: Node3D = $LevelNotgrid/Tiles
@onready var levelTiles : Array[Node] = levelTileMaster.get_children()
@onready var donut: MeshInstance3D = $Donut

var tileArray = []

func _ready():
	donut.position = $LevelNotgrid/Tiles/Tile1.position
	
	print("Tile: "+ str(levelTileMaster.get_child(19)) + "- next tile: " + str(levelTileMaster.get_child(19).get_node_north()))


#region == DEBUG ==
func _input(event):
	if event.is_action_pressed("select"):
		
		var random = randi_range(0,255)
		
		## Move placeholder donut to random cell to demonstrate grid movement
		if levelTiles[random].walkable:
			donut.position = levelTiles[random].position
			
			var currCell : Vector3i = levelTiles[random].get_cell_pos()
			
			print("Donut moved to cell position: " + str(currCell) + ", or " + str(level.get_cell(currCell).name))
			
			level.get_cell(currCell)
		else:
			print("unwalkable at index: " + str(random))
#endregion == DEBUG ==
