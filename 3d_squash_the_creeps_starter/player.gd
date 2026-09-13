class_name Player extends CharacterBody3D
## Speed
@export var speed = 14
@export var jump_speed = 20
@export var bounce_speed = 15
## Gravity
@export var fall_accelartion = 75
## Base Velocity
var target_velocity = Vector3.ZERO

## Hit by mob
signal hit
func _ready() -> void:
	pass
func _physics_process(delta: float) -> void:
	
	var direction = Vector3.ZERO
	
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_just_pressed("jump") && is_on_floor():
		target_velocity.y = jump_speed
		
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Pivot/Character/AnimationPlayer.speed_scale = 1.5
	else:
		$Pivot/Character/AnimationPlayer.speed_scale = 1
		
	var dirXZ = Vector3(direction.x,0,direction.z)
	if dirXZ != Vector3.ZERO:
		$Pivot.basis = Basis.looking_at(dirXZ)
		
	# Ground velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	# Air velocity
	if not is_on_floor():
		target_velocity.y -= fall_accelartion * delta

	velocity = target_velocity
	move_and_slide()
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		# Có khả năng duplicate collsion trong 1 frame
		if collision.get_collider() == null:
			continue
		
		# Collide với mob
		if collision.get_collider().is_in_group("mob"):
			var mob = collision.get_collider()
			# hitting từ trên xuống
			if Vector3.UP.dot(collision.get_normal()) > 0.74:
				mob.squash()
				target_velocity.y = bounce_speed
				#1 frame tối đa hit đc 1 con
				break


func _on_mob_detector_body_entered(_body: Node3D) -> void:
	hit.emit()
	#Player die
	queue_free()
