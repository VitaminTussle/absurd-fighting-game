class_name ChooseYourFighterMenu extends Control

const Fighters = ChooseFighterInfo.Fighters

signal start(p1_choice: Fighters, p2_choice: Fighters)
signal quit_to_menu

var p1_choice: Fighters = -1
var p2_choice: Fighters = Fighters.THREE_RACCOONS_IN_A_TRENCHCOAT

# engine methods

func _ready():
	%P1CharacterLabel.text = _get_text_from_fighters_enum(p1_choice)
	%P2CharacterLabel.text = _get_text_from_fighters_enum(p2_choice)

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept") and p1_choice != -1 and p2_choice != -1:
		start.emit(p1_choice, p2_choice)
	if Input.is_action_just_pressed("ui_cancel"):
		quit_to_menu.emit()

# signal connections

func _on_dollar_store_employee_button_pressed():
	p1_choice = Fighters.DOLLAR_STORE_EMPLOYEE
	%P1CharacterLabel.text = _get_text_from_fighters_enum(p1_choice)

func _on_three_raccoons_in_a_trenchcoat_button_pressed():
	p1_choice = Fighters.THREE_RACCOONS_IN_A_TRENCHCOAT
	%P1CharacterLabel.text = _get_text_from_fighters_enum(p1_choice)

# private utils methods

func _get_text_from_fighters_enum(choice: Fighters):
	match choice:
		Fighters.DOLLAR_STORE_EMPLOYEE:
			return "Dollar Store Employee"
		Fighters.THREE_RACCOONS_IN_A_TRENCHCOAT:
			return "Three Raccoons in a Trenchcoat"
		_:
			return "Selecting..."

