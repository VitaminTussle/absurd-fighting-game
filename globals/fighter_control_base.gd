extends CharacterBody2D

@export var player_number := 1
@export var gravity := 1000
@export var jump_velocity := -400
@export var fast_fall_multiplier := 3
@export var walk_speed := 200

signal deal_damage(to_player: int, amount: float)

var raycast: FighterFinderRaycast = null
var can_double_jump := false
var is_fast_falling := false

# engine methods

func _physics_process(delta):
	if not is_on_floor():
		if Input.is_action_just_pressed(_get_input_name("down")):
			is_fast_falling = true
		velocity.y += gravity * delta * (fast_fall_multiplier if is_fast_falling else 1)
	else:
		can_double_jump = true
		is_fast_falling = false
	
	if Input.is_action_just_pressed(_get_input_name("up")) and (is_on_floor() or can_double_jump):
		velocity.y = jump_velocity
		is_fast_falling = false
		if can_double_jump and not is_on_floor():
			can_double_jump = false
	
	var horiz_direction = Input.get_axis(_get_input_name("left"), _get_input_name("right"))
	var vert_direction = Input.get_axis(_get_input_name("up"), _get_input_name("down"))
	if horiz_direction:
		# if trying to go right and left raycast is maxed out, or if trying to go left and right raycast is maxed out, uh, don't
		var maxed_out := raycast != null and ((horiz_direction > 0 and raycast.left_max) or (horiz_direction < 0 and raycast.right_max))
		if not maxed_out:
			velocity.x = horiz_direction * walk_speed
		else:
			velocity.x = move_toward(velocity.x, 0, walk_speed)
	else:
		velocity.x = move_toward(velocity.x, 0, walk_speed)
	
	if Input.is_action_just_pressed(_get_input_name("light")):
		light_attack(velocity.y != 0, horiz_direction, vert_direction)
	if Input.is_action_just_pressed(_get_input_name("heavy")):
		heavy_attack(velocity.y != 0, horiz_direction, vert_direction)
	if Input.is_action_just_pressed(_get_input_name("special")):
		special_attack(velocity.y != 0, horiz_direction, vert_direction)
	
	move_and_slide()

# overridable methods

func light_attack(in_air: bool, horiz_dir: float, vert_dir: float):
	pass

func heavy_attack(in_air: bool, horiz_dir: float, vert_dir: float):
	pass

func special_attack(in_air: bool, horiz_dir: float, vert_dir: float):
	pass

# private utils methods

func _get_input_name(action: String):
	return "p" + str(player_number) + "_" + action
