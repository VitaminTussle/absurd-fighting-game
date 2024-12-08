extends CharacterBody2D

const FWD_WALK_ANIM = "fwd_walk"
const BKWD_WALK_ANIM = "bkwd_walk"

@export var player_number := 1
@export var gravity := 1000
@export var jump_velocity := -400
@export var fast_fall_multiplier := 3
@export var walk_speed := 200

signal deal_damage(to_player: int, amount: float)

var raycast: FighterFinderRaycast = null
var animation: AnimatedSprite2D = null
var can_double_jump := false
var is_fast_falling := false
var x_limit := 0
var facing_right := true

var has_connected_signals := false

# engine methods

func _physics_process(delta):
	if animation != null and !has_connected_signals:
		animation.animation_finished.connect(_idle_on_anim_finish)
		has_connected_signals = true
	
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
		# if trying to go right and left raycast is maxed out, or if trying to go left and right raycast is maxed out, or if trying to go past x limit, uh, don't
		var maxed_out := raycast != null and (
			(horiz_direction > 0 and raycast.left_max) or
			(horiz_direction < 0 and raycast.right_max) or
			(horiz_direction < 0 and position.x <= x_limit * -1) or
			(horiz_direction > 0 and position.x >= get_viewport_rect().size.x + x_limit)
		)
		if not maxed_out:
			velocity.x = horiz_direction * walk_speed
		else:
			velocity.x = move_toward(velocity.x, 0, walk_speed)
			if animation != null and (animation.animation == FWD_WALK_ANIM or animation.animation == BKWD_WALK_ANIM):
				animate_stop_moving()
		# process correct moving animation
		if raycast != null:
			if horiz_direction > 0 and raycast.right_ray.is_colliding():
				facing_right = true
				animate_move_forward()
			elif horiz_direction < 0 and raycast.left_ray.is_colliding():
				facing_right = false
				animate_move_forward()
			elif horiz_direction > 0 and raycast.left_ray.is_colliding():
				facing_right = false
				animate_move_backward()
			else:
				facing_right = true
				animate_move_backward()
	else:
		velocity.x = move_toward(velocity.x, 0, walk_speed)
		if animation != null and (animation.animation == FWD_WALK_ANIM or animation.animation == BKWD_WALK_ANIM):
				animate_stop_moving()
	
	if Input.is_action_just_pressed(_get_input_name("light")):
		light_attack(velocity.y != 0, horiz_direction, vert_direction)
	if Input.is_action_just_pressed(_get_input_name("heavy")):
		heavy_attack(velocity.y != 0, horiz_direction, vert_direction)
	if Input.is_action_just_pressed(_get_input_name("special")):
		special_attack(velocity.y != 0, horiz_direction, vert_direction)
	
	move_and_slide()

# overridable methods

func animate_move_forward():
	pass

func animate_move_backward():
	pass

func animate_stop_moving():
	pass

func light_attack(in_air: bool, horiz_dir: float, vert_dir: float):
	pass

func heavy_attack(in_air: bool, horiz_dir: float, vert_dir: float):
	pass

func special_attack(in_air: bool, horiz_dir: float, vert_dir: float):
	pass

# private utils methods

func _get_input_name(action: String):
	return "p" + str(player_number) + "_" + action

func _idle_on_anim_finish():
	if animation.animation != FWD_WALK_ANIM and animation.animation != BKWD_WALK_ANIM:
		animate_stop_moving()
