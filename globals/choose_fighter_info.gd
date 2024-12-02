class_name ChooseFighterInfo

enum Fighters {
	DOLLAR_STORE_EMPLOYEE,
	THREE_RACCOONS_IN_A_TRENCHCOAT
}

static func enum_to_node(fighter: Fighters):
	match fighter:
		Fighters.DOLLAR_STORE_EMPLOYEE:
			return preload("res://fighters/dollar_store_employee/dollar_store_employee.tscn").instantiate()
		Fighters.THREE_RACCOONS_IN_A_TRENCHCOAT:
			return preload("res://fighters/three_raccoons_in_a_trenchcoat/three_raccoons_in_a_trenchcoat.tscn").instantiate()
		_:
			return null
