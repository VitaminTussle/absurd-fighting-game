extends FighterControlBase

# engine methods

func _ready():
	raycast = $FighterFinderRaycast
	animation = %Animation
	animation.play("idle")

func _process(delta):
	if facing_right:
		animation.flip_h = false
	else:
		animation.flip_h = true

# superclass extended methods

func animate_move_forward():
	animation.play("fwd_walk")

func animate_move_backward():
	animation.play("bkwd_walk")

func animate_stop_moving():
	animation.play("idle")

func light_attack(in_air: bool, horiz_dir: float, vert_dir: float):
	# grounded attacks
	if not in_air:
		if horiz_dir == 0 and vert_dir == 0:
			grounded_jab()

# specific attack methods

func grounded_jab():
	$GroundedJab.visible = true
	if $GroundedJab.has_overlapping_bodies():
		deal_damage.emit(2 if player_number == 1 else 1, 10)
	animation.play("grounded_light_attack")
