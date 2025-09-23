extends Node3D

@onready var level: Node3D = $LevelNotgrid
@onready var levelTileMaster: Node3D = $LevelNotgrid/Tiles
@onready var levelTiles : Array[Node] = levelTileMaster.get_children()
@onready var donut: MeshInstance3D = $Donut

var tileArray = []

func _ready():
	donut.position = $LevelNotgrid/Tiles/Tile1.position


func _input(event):
	if event.is_action_pressed("select"):
		#print("Amabatakum")
		#print(levelTiles)
		
		var random = randi_range(0,200)
		
		donut.position = levelTiles[random].position
