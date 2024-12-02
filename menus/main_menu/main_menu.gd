extends Control

signal play

func _on_play_button_pressed():
	play.emit()

func _on_options_button_pressed():
	pass # TODO

func _on_exit_button_pressed():
	get_tree().quit()
