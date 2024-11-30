class_name FighterFinderRaycast extends Node2D

const MAX_DISTANCE = 500

@onready var left_ray := $LeftRayCast
@onready var right_ray := $RightRayCast

var left_max := false
var right_max := false

func _physics_process(_delta):
	if left_ray.is_colliding():
		var loc_collision_pt := to_local(left_ray.get_collision_point())
		var collision_distance := absf(loc_collision_pt.x)
		if collision_distance >= MAX_DISTANCE:
			left_max = true
		else:
			left_max = false
	else:
		left_max = false
	if right_ray.is_colliding():
		var loc_collision_pt := to_local(right_ray.get_collision_point())
		var collision_distance := absf(loc_collision_pt.x)
		if collision_distance >= MAX_DISTANCE:
			right_max = true
		else:
			right_max = false
	else:
		right_max = false
