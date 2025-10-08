extends Node
class_name Pathfinder

## This class isn't meant to do anything other than execute pathfinding algorithms ##

static func get_reachable(level: LevelNotGrid, unit: Node3D) -> Dictionary:
	# returns { Vector3i : bool } as { cell : walkable }
	var frontier := [unit.cell.get_cell_pos()]
	var visited: Dictionary = {}
	visited[unit.cell.get_cell_pos()] = 0		# Cost so far; init as 0
	
	while frontier.size() > 0:
		var current: Vector3i = frontier.pop_front()
		var costSoFar: int = visited[current]
		
		for n in _neighbors(current):
			if not level.has_cell(n):
				continue
			
			if level.get_cell(n).has_occupant():
				continue
			
			var stepCost := level.get_cell(n).terrain_cost
			var newCost := costSoFar + stepCost
			if newCost <= unit.movePoints and (not visited.has(n) or newCost < int(visited[n])):
				visited[n] = newCost
				frontier.push_back(n)
	
	visited.erase(unit.cell)
	print("Pathfinder executed")
	return _keys_as_set(visited)

static func _neighbors(c: Vector3i) -> Array[Vector3i]:
	return [
		Vector3i(c.x + 2, 0, c.z),
		Vector3i(c.x - 2, 0, c.z),
		Vector3i(c.x, 0, c.z + 2),
		Vector3i(c.x, 0, c.z - 2),
	]

static func _keys_as_set(d: Dictionary) -> Dictionary:
	var out: Dictionary = {}
	for k in d.keys():
		out[k] = true
	#print(str(d))
	#print("Out: ", str(out))
	return out
