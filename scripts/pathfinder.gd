extends Node
class_name Pathfinder

## This class isn't meant to do anything other than execute pathfinding algorithms ##

# Get all reachable tiles
static func get_reachable(level: LevelNotGrid, unit: Interactable) -> Dictionary:
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
	
	visited.erase(unit.cell.get_cell_pos())
	print("Pathfinder executed")
	return _keys_as_set(visited)

static func get_units_reachable(level: LevelNotGrid, unit: Interactable) -> Dictionary:
	# Returns { Vector3i : bool } for tiles that have units and are within move range
	# E.g { Vector3i(cellpos) : true/walkable }
	var frontier := [unit.cell.get_cell_pos()]
	var visited: Dictionary = {}
	visited[unit.cell.get_cell_pos()] = 0  # Cost so far; init as 0
	
	while frontier.size() > 0:
		var current: Vector3i = frontier.pop_front()
		var costSoFar: int = visited[current]
		
		for n in _neighbors(current):
			if not level.has_cell(n):
				continue

			var cell = level.get_cell(n)
			var stepCost : int = 1		## Attack range is unaffected by terrain cost
			var newCost : int = costSoFar + stepCost
			
			# Explore all cells until movePoints are empty
			if newCost <= unit.attackRange and (not visited.has(n) or newCost < int(visited[n])):
				visited[n] = newCost
				frontier.push_back(n)
	
	# Filter: only keep positions that actually have an occupant
	var result: Dictionary = {}
	for cell in visited.keys():
		var tile = level.get_cell(cell)
		
		if tile.has_occupant() and cell != unit.cell.get_cell_pos():
			if tile.get_occupant() is EnviromentalObject:
				result[cell] = true			## Detect objects
			
			else:
				if tile.get_occupant().playerUnit != unit.playerUnit:
					result[cell] = true
	
	return result


## Find the ideal path - Use for unit movement
static func find_path(level : LevelNotGrid, unit: Interactable, goal: Vector3i) -> Array[Vector3i]:
	
	var start: Vector3i = unit.cell.get_cell_pos()		# Start with current cell pos
	var cameFrom: Dictionary = {}
	var costSoFar: Dictionary = {}
	
	# Simple prio queue using array {cell, prio}
	var frontier: Array = []
	_push_frontier(frontier, start, 0)
	cameFrom[start] = null
	costSoFar[start] = 0
	
	while frontier.size() > 0:
		var current: Vector3i = _pop_lowest(frontier)
		if current == goal:
			break
		
		for n in _neighbors(current):
			if not level.has_cell(n): continue
			if level.get_cell(n).has_occupant() and n != goal:
				continue
			#if not level.get_cell(n).walkable: continue
			
			var newCost : int = int(costSoFar[current]) + int(level.get_cell(n).terrain_cost)
			if (not costSoFar.has(n)) or (newCost < int(costSoFar[n])):
				costSoFar[n] = newCost
				
				var priority = newCost + _manhattan(current, goal)
				_push_frontier(frontier, n, priority)
				cameFrom[n] = current
	
	if not cameFrom.has(goal):
		return []

	var path: Array[Vector3i] = []
	var node: Vector3i = goal
	while node != start:
		path.push_front(node)
		node = cameFrom.get(node, start)
	path.push_front(start)
	print("Path is: ", str(path))
	return path

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

static func _manhattan(a: Vector3i, b: Vector3i) -> int:
	return (abs(a.x - b.x) + abs(a.z - b.z)) / 2

static func _push_frontier(frontier: Array, cell: Vector3i, prio: int) -> void:
	frontier.append({"c": cell, "p": prio})

static func _pop_lowest(frontier: Array) -> Vector3i:
	var bestI := 0
	var bestP = frontier[0]["p"]
	for i in range(1, frontier.size()):
		var p = frontier[i]["p"]
		if p < bestP:
			bestP = p
			bestI = i
	
	var out: Vector3i = frontier[bestI]["c"]
	frontier.remove_at(bestI)
	return out
