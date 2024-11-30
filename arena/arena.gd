extends Node2D

const CAMERA_X_LIMIT = 1000

@onready var player_1: FighterControlBase
@onready var player_2: FighterControlBase

func _ready():
	var vp_size = get_viewport().size
	player_1 = preload("res://fighters/dollar_store_employee/dollar_store_employee.tscn").instantiate()
	player_1.player_number = 1
	player_1.position.x = vp_size.x / 4
	player_1.position.y = vp_size.y * 2 / 3
	add_child(player_1)
	player_2 = preload("res://fighters/three_raccoons_in_a_trenchcoat/three_raccoons_in_a_trenchcoat.tscn").instantiate()
	player_2.player_number = 2
	player_2.position.x = vp_size.x * 3 / 4
	player_2.position.y = vp_size.y * 2 / 3
	add_child(player_2)
	
	%ArenaCam.limit_left = CAMERA_X_LIMIT * -1
	%ArenaCam.limit_right = vp_size.x + CAMERA_X_LIMIT

func _process(delta):
	var vp_size = get_viewport().size
	%ArenaCam.position.x = vp_size.x / 2 if not player_1 or not player_2 else ((player_1.position.x + player_2.position.x) / 2)
	%ArenaCam.position.y = vp_size.y / 2
