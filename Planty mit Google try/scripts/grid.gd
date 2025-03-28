extends Node2D

@export var hex_scene: PackedScene  # Weise hier die hex.tscn Szene zu!
@export var grid_width: int = 10
@export var grid_height: int = 8
@export var hex_radius: float = 50

@onready var player1 = $Player1 #Weise die Player Nodes im Editor zu!
@onready var player2 = $Player2

var grid = {}  # Dictionary to store hexes: (q, r) -> Hex Node
var current_player: int = 1


func _ready():
	generate_grid()
	player1.player_id = 1 #Wichtig: Player ID zuweisen!
	player2.player_id = 2 #Wichtig: Player ID zuweisen!
	print("Player 1 ID: ", player1.player_id) #Debug
	print("Player 2 ID: ", player2.player_id) #Debug

func generate_grid():
	for q in range(grid_width):
		for r in range(grid_height):
			var hex = hex_scene.instantiate()
			var world_pos = axial_to_world(q, r)
			hex.position = world_pos
			hex.q = q  # Axial Coordinate q
			hex.r = r  # Axial Coordinate r
			hex.radius = hex_radius #Übergebe den Radius an das Hex
			add_child(hex)
			grid[str(q) + "," + str(r)] = hex  # Store in the grid dictionary
			hex.connect("hex_clicked", _on_hex_clicked) #Verbinde das Signal

func axial_to_world(q: int, r: int) -> Vector2:
	var x = hex_radius * (3.0/2.0 * q)
	var y = hex_radius * (sqrt(3)/2 * q + sqrt(3) * r)
	return Vector2(x, y)

func get_neighbors(q: int, r: int) -> Array[Vector2i]:
	var neighbors: Array[Vector2i] = []
	neighbors.append(Vector2i(q + 1, r))
	neighbors.append(Vector2i(q - 1, r))
	neighbors.append(Vector2i(q, r + 1))
	neighbors.append(Vector2i(q, r - 1))
	neighbors.append(Vector2i(q + 1, r - 1))
	neighbors.append(Vector2i(q - 1, r + 1))
	return neighbors

func spread(hex: Node2D):
	var neighbors = get_neighbors(hex.q, hex.r)
	for neighbor_coords in neighbors:
		var neighbor = grid.get(str(neighbor_coords.x) + "," + str(neighbor_coords.y))
		if neighbor:
			if neighbor.tile_owner != current_player:
				neighbor.spread_points += 1  #Erhöhe die Spreadpoints des Feldes
				if neighbor.spread_points >= neighbor.resistance:
					neighbor.tile_owner = current_player #Wechsle den Besitzer
					neighbor.spread_points = 0 #Setze die Spreadpoints zurück
					print("Field Captured!") #Debug
					#TODO: Visuelles Update des Hex-Feldes (Farbe ändern)
					update_hex_visual(neighbor)

func update_hex_visual(hex: Node2D):
	#TODO: Implementiere hier die visuelle Änderung des Hex-Feldes
	#z.B. Ändere die Farbe des Polygon2D basierend auf dem tile_owner
	if hex.tile_owner == 1:
		hex.get_node("Polygon2D").color = Color("green") #Beispiel
	elif hex.tile_owner == 2:
		hex.get_node("Polygon2D").color = Color("red") #Beispiel
	else:
		hex.get_node("Polygon2D").color = Color("white") #Neutral

func next_turn():
	current_player = 2 if current_player == 1 else 1
	print("Current Player:", current_player)

func get_current_player_node():
	if current_player == 1:
		return player1
	else:
		return player2

func use_ability(hex: Node2D, ability_name: String):
	var current_player_node = get_current_player_node()
	if current_player_node.abilities_cooldowns[ability_name] > 0:
		print("Ability ", ability_name, " is on cooldown")
		return #Macht nichts wenn die Ability auf Cooldown ist
	if current_player_node.has_enough_resources(ability_name):
		current_player_node.spend_resources(ability_name)
		#Effekt der Ability hier
		if ability_name == "growth_spurt":
			hex.spread_points += 20
			print("Used Growth Spurt!")
		elif ability_name == "poison_field":
			#Irgendwas böses mit dem Feld anstellen
			print("Used Poison Field")
		current_player_node.abilities_cooldowns[ability_name] = current_player_node.max_cooldowns[ability_name]
	else:
		print("Nicht genügend Ressourcen!")

func _on_hex_clicked(hex: Node2D):
	print("Hex Clicked at Axial Coordinates: ", hex.q, ", ", hex.r)
	var current_player_node = get_current_player_node()

	if hex.tile_owner == current_player:
		# Zeige UI mit Fähigkeiten-Optionen (das UI kommt später)
		# Fürs Erste: Einfach eine Fähigkeit zufällig auswählen
		var random_ability = current_player_node.available_abilities[randi_range(0, current_player_node.available_abilities.size() - 1)]

		use_ability(hex, random_ability)
	else:
		print("Dieses Feld gehört dir nicht!")

func _process(delta):
	#...
	if current_player == 1:
		player1.update_cooldowns(delta)
	if current_player == 2:
		player2.update_cooldowns(delta)
