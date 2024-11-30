extends Node2D

const CAMERA_X_LIMIT = 1000

@onready var player_1: FighterControlBase
@onready var player_2: FighterControlBase

var p1_hp := 100.0
var p2_hp := 100.0

# engine methods

func _ready():
	var vp_size = get_viewport().size
	player_1 = preload("res://fighters/dollar_store_employee/dollar_store_employee.tscn").instantiate()
	player_1.player_number = 1
	player_1.position.x = vp_size.x / 4
	player_1.position.y = vp_size.y * 2 / 3
	player_1.deal_damage.connect(_deal_damage)
	add_child(player_1)
	player_2 = preload("res://fighters/three_raccoons_in_a_trenchcoat/three_raccoons_in_a_trenchcoat.tscn").instantiate()
	player_2.player_number = 2
	player_2.position.x = vp_size.x * 3 / 4
	player_2.position.y = vp_size.y * 2 / 3
	player_2.deal_damage.connect(_deal_damage)
	add_child(player_2)
	
	%ArenaCam.limit_left = CAMERA_X_LIMIT * -1
	%ArenaCam.limit_right = vp_size.x + CAMERA_X_LIMIT

func _process(delta):
	var vp_size = get_viewport().size
	%ArenaCam.position.x = vp_size.x / 2 if not player_1 or not player_2 else ((player_1.position.x + player_2.position.x) / 2)
	%ArenaCam.position.y = vp_size.y / 2

# util methods

func _deal_damage(to_player: int, amount: float):
	print("dealing " + str(amount) + " damage to player " + str(to_player))
	p1_hp -= amount if to_player == 1 else 0.0
	p2_hp -= amount if to_player == 2 else 0.0
	if p1_hp <= 0 or p2_hp <= 0:
		print("game over!")
