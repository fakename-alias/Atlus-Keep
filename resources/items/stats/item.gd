extends Resource

class_name Item

@export var name: String = "Unnamed"
@export var description: String = "No Description"
@export var icon: Texture2D
@export var stackable: bool = false
@export var max_stack: int = 1
#this will be changed to the dimensions of a weapon later for the inventory systemm e.g shortsword is 1x2
@export var weight: int = 1
@export var value: int = 0
