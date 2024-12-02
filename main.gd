extends Node2D

@onready var main_menu = %MainMenu
@onready var choose_fighter_menu = %ChooseYourFighterMenu

var arena_preload = null
var arena: Arena = null

func _ready():
	arena_preload = preload("res://arena/arena.tscn")

func _on_arena_quit():
	main_menu.visible = false
	choose_fighter_menu.visible = true
	remove_child(arena)
	arena = null

func _on_main_menu_play():
	main_menu.visible = false
	choose_fighter_menu.visible = true

func _on_choose_your_fighter_menu_start(p1_choice, p2_choice):
	if choose_fighter_menu.visible:
		main_menu.visible = false
		choose_fighter_menu.visible = false
		arena = arena_preload.instantiate()
		arena.quit_to_menu.connect(_on_arena_quit)
		arena.p1_choice = p1_choice
		arena.p2_choice = p2_choice
		add_child(arena)

func _on_choose_your_fighter_menu_quit_to_menu():
	main_menu.visible = true
	choose_fighter_menu.visible = false
