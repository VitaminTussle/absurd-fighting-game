extends FighterControlBase

# engine methods

func _ready():
	raycast = $FighterFinderRaycast

# superclass extended methods

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
