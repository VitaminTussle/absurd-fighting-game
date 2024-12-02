class_name Arena extends Node2D

signal quit_to_menu

const Fighters = ChooseFighterInfo.Fighters
const CAMERA_X_LIMIT = 1000

@onready var player_1: FighterControlBase
@onready var player_2: FighterControlBase

var p1_choice: Fighters = -1
var p2_choice: Fighters = -1
var p1_hp := 100.0
var p2_hp := 100.0

# engine methods

func _ready():
	var vp_size = get_viewport().size
	player_1 = ChooseFighterInfo.enum_to_node(p1_choice)
	player_1.player_number = 1
	player_1.position.x = vp_size.x / 4
	player_1.position.y = vp_size.y * 2 / 3
	player_1.x_limit = CAMERA_X_LIMIT
	player_1.deal_damage.connect(_deal_damage)
	add_child(player_1)
	player_2 = ChooseFighterInfo.enum_to_node(p2_choice)
	player_2.player_number = 2
	player_2.position.x = vp_size.x * 3 / 4
	player_2.position.y = vp_size.y * 2 / 3
	player_2.x_limit = CAMERA_X_LIMIT
	player_2.deal_damage.connect(_deal_damage)
	add_child(player_2)
	
	%ArenaCam.limit_left = CAMERA_X_LIMIT * -1
	%ArenaCam.limit_right = vp_size.x + CAMERA_X_LIMIT

func _process(delta):
	var vp_size = get_viewport().size
	%ArenaCam.position.x = vp_size.x / 2 if not player_1 or not player_2 else ((player_1.position.x + player_2.position.x) / 2)
	%ArenaCam.position.y = vp_size.y / 2
	
	if Input.is_action_just_pressed("ui_cancel"):
		quit_to_menu.emit()

# util methods

func _deal_damage(to_player: int, amount: float):
	print("dealing " + str(amount) + " damage to player " + str(to_player))
	p1_hp -= amount if to_player == 1 else 0.0
	p2_hp -= amount if to_player == 2 else 0.0
	if p1_hp <= 0 or p2_hp <= 0:
		print("game over!")
