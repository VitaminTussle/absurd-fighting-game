extends CharacterBody2D

@export var player_number := 1
@export var gravity := 1000
@export var jump_velocity := -400
@export var fast_fall_multiplier := 3
@export var walk_speed := 200

var can_double_jump := false
var is_fast_falling := false

func _physics_process(delta):
	if not is_on_floor():
		if Input.is_action_just_pressed(get_input_name("down")):
			is_fast_falling = true
		velocity.y += gravity * delta * (fast_fall_multiplier if is_fast_falling else 1)
	elif velocity.y == 0:
		can_double_jump = true
		is_fast_falling = false
	
	if Input.is_action_just_pressed(get_input_name("up")) and (is_on_floor() or can_double_jump):
		velocity.y = jump_velocity
		if can_double_jump and not is_on_floor():
			can_double_jump = false
	
	var direction = Input.get_axis(get_input_name("left"), get_input_name("right"))
	if direction:
		velocity.x = direction * walk_speed
	else:
		velocity.x = move_toward(velocity.x, 0, walk_speed)
	
	move_and_slide()

func get_input_name(action: String):
	return "p" + str(player_number) + "_" + action
