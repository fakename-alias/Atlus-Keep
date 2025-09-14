extends Node

var entity_list = []
var action_queue = []
var simulated_turn = 0
var current_turn = 0

var e_no # Temporary variable for testing purposes

@export var entity_path: Node # Path to where the entities are stored, change as necessary

func _ready() -> void:
	e_no = get_children().size() + 1 # Temporary variable for testing purposes
	entity_list = get_entities()
	# Uncomment these if you want to see each entity's Readiness Gain stat
	#for e in entity_list:
		#print (e.name + " is Playable: " + str(e.is_playable) + ", Readiness Gain: " + str(e.readiness_gain))
	current_turn = 1

func _process(delta: float) -> void:
	# Calculate the turn order if not during any entity's turn
	if (entity_list.all(func(entity): return entity.turn_done)):
		# Remove from the action queue any removed entity
		var removal_list = []
		for i in action_queue.size():
			if (entity_list.find(action_queue[i]) == -1):
				removal_list.append(i)
		while (!removal_list.is_empty()):
			action_queue.remove_at(removal_list.pop_back())
		# Caluclate ahead until each entity is in the action queue at least once
		if (entity_list.any(func(entity): return (action_queue.find(entity) == -1))):
			#print(action_queue)
			# Create and sort the ready queue
			for entity in decide_turn_order(prepare(entity_list)):
				# Add the entity to the action queue
				action_queue.append(entity)
				entity.readiness = 0
		# After each entity's next turn is known, display how many turns away is each entity's turn.
		# Also call get_turn() for the current active entity.
		else:
			# Execute the action queue
			if (!action_queue.is_empty()):
				# Hook these print statements to the UI
				print("Current turn: " + str(current_turn))
				for entity in entity_list:
					print(entity.name + " is " + str(action_queue.find(entity)) + " turn(s) away.")
				action_queue.pop_front().get_turn() # <-- Where the current entity's turn is called
				current_turn += 1
				print("----------") # Just for readability on the debugger
			else:
				# If somehow all entities disappeared, both playable and non-playable, put something here.
				print("Everyone died")

# Get all the entities
func get_entities() -> Array:
	var e_list = []
	# For now it just gets all nodes that are children of whatever node is at the end of
	# entity_path that are also named "entity" + a number. Change as necessary
	for node in entity_path.get_children():
		if (node.name.match("entity*")):
			e_list.append(node)
	return e_list

# Increase Readiness of all characters
func prepare(e_list: Array) -> Array:
	var readied_entities = []
	for e in e_list:
		# If any character's Readiness is 100 or higher, add to queue
		if (e.readiness >= 100):
			readied_entities.append(e)
	# If there are no readied characters in queue, increase Readiness of everyone by their Readiness Gain
	if (readied_entities.is_empty()):
		for e in e_list:
			e.readiness += e.readiness_gain
			#print(e.name + "'s current Readiness: " + str(e.readiness))
	return readied_entities

# Sort the array of readied entities by priorities
func decide_turn_order(readied_entities: Array) -> Array:
	if (readied_entities.is_empty()): return []
	
	var sorted_readied_entities = []
	var fastest_e = readied_entities[0]
	for e in readied_entities:
		# Playable entities take priority
		if (e.is_playable < fastest_e.is_playable):
			continue
		elif (e.is_playable > fastest_e.is_playable):
			fastest_e = e
			continue
		# Entities with higher Readiness take priority
		if (e.readiness < fastest_e.readiness):
			continue
		elif (e.readiness > fastest_e.readiness):
			fastest_e = e
			continue
		# Entities with higher Readiness Gain take priority
		if (e.readiness_gain < fastest_e.readiness_gain):
			continue
		elif (e.readiness_gain > fastest_e.readiness_gain):
			fastest_e = e
			continue
		# Entities with higher Dex take priority
		if (e.dex < fastest_e.dex):
			continue
		elif (e.dex > fastest_e.dex):
			fastest_e = e
			continue
		# Cointoss
		if (randi() % 2 == 0):
			fastest_e = e
	# Append into sorted array
	sorted_readied_entities.append(fastest_e)
	return sorted_readied_entities

# Temporary commands for testing purposes
func _input(event: InputEvent) -> void:
	# Press Q to add a new entity
	if ((event.as_text() == "Q") and event.is_released()):
		var node = preload("res://turn order/entity_placeholder.tscn").instantiate()
		node.set_name("entity" + str(e_no))
		add_child(node)
		e_no += 1
		entity_list = get_entities()
	# Press E to remove a random entity
	elif ((event.as_text() == "E") and event.is_released()):
		remove_child(entity_list[randi() % entity_list.size()])
		entity_list = get_entities()
