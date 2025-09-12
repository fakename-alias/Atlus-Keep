extends Node

var entity_list = []
var current_turn = 0

@export var entity_path: Node # Path to where the entities are stored, change as necessary

func _ready() -> void:
	entity_list = get_entities()
	#for e in entity_list:
		#print (e.name + " is Playable: " + str(e.is_playable) + ", Readiness Gain: " + str(e.readiness_gain))

func _physics_process(delta: float) -> void:
	# Call entity_list = get_entities() in here when entities are removed or added (killed/summoned?)
	# Actual turn ordering
	if (entity_list.all(func(e): return e.turn_done)):
		var ready_queue = decide_turn_order(prepare(entity_list))
		for current_entity in ready_queue:
			current_turn += 1
			print("Current turn: " + str(current_turn))
			current_entity.get_turn()

# Get list of entities in the scene
# Change as necessary
func get_entities() -> Array:
	var e_list = []
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
