extends Node

@export var player_id: int = 1  # Eindeutige ID
var resources: Dictionary = {
	"sunlight": 100,
	"nutrients": 50
}
var available_abilities: Array[String] = ["growth_spurt", "poison_field"] #Ability Namen!
var abilities_cooldowns: Dictionary = { #Cooldowns der Abilities
	"growth_spurt": 0,
	"poison_field": 0
}
var max_cooldowns: Dictionary = { #Maximale Cooldowns der Abilities
	"growth_spurt": 3,
	"poison_field": 5
}


func has_enough_resources(ability_name: String) -> bool:
	# Hier kommt die Logik, um zu überprüfen, ob der Spieler genug Ressourcen hat, um die Fähigkeit zu nutzen
	# Zum Beispiel:
	if ability_name == "growth_spurt":
		return resources["sunlight"] >= 20  #Beispiel
	elif ability_name == "poison_field":
		return resources["nutrients"] >= 30 #Beispiel
	return false

func spend_resources(ability_name: String):
	#Hier die Logik die Ressourcen verbraucht
	if ability_name == "growth_spurt":
		resources["sunlight"] -= 20
	elif ability_name == "poison_field":
		resources["nutrients"] -= 30
	print("Resources Sunlight: ", resources["sunlight"]) #Debug
	print("Resources Nutrients: ", resources["nutrients"]) #Debug

func update_cooldowns(delta):
	for ability in abilities_cooldowns:
		if abilities_cooldowns[ability] > 0:
			abilities_cooldowns[ability] -= delta
			abilities_cooldowns[ability] = max(0,abilities_cooldowns[ability]) #Verhindert negative Werte
			print("Cooldown: ", ability, " ", abilities_cooldowns[ability]) #Debug
