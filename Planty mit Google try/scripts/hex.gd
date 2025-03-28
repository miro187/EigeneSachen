extends Node2D

signal hex_clicked(hex) #Signal wenn geklickt

@export var q: int  # Axial Coordinate q
@export var r: int  # Axial Coordinate r
@export var radius: float = 50
var points = PackedVector2Array()
@onready var area_2d = $Area2D
@onready var polygon_2d = $Polygon2D
var tile_owner = 0 # 0 = Neutral, 1 = Spieler 1, 2 = Spieler 2, usw.
var spread_points: float = 0 #Ausbreitungspunkte
var resistance: float = 10 #Widerstand gegen ausbreitung

func _ready():
	_update_polygon()
	area_2d.input_pickable = true # Stelle sicher, dass Klicks erkannt werden

func _update_polygon():
	points.clear()
	for i in range(6):
		var angle = TAU / 6 * i  # TAU = 2 * PI (voller Kreis)
		var x = radius * cos(angle)
		var y = radius * sin(angle)
		points.append(Vector2(x, y))
	polygon_2d.polygon = points
	$Area2D/CollisionPolygon2D.polygon = points

func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		emit_signal("hex_clicked", self)  # Gib das Signal aus
