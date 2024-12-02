extends Node2D

@onready var main_menu = %MainMenu

var arena_preload = null
var arena: Arena = null

func _ready():
	arena_preload = preload("res://arena/arena.tscn")

func _on_arena_quit():
	main_menu.visible = true
	remove_child(arena)
	arena = null

func _on_main_menu_play():
	main_menu.visible = false
	arena = arena_preload.instantiate()
	arena.quit_to_menu.connect(_on_arena_quit)
	add_child(arena)
