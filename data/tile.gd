extends Node
class_name Tile

## Tile data

@export var walkable : bool = true 	## Can the surface be traversed? 
@export var terrain_cost : int = 1 	## How much AP to move over it?

@onready var root: Node3D = $"../.."

#Get cell pos
func get_cell_pos() -> Vector3i:
	return root.world_to_cell(self.position)
