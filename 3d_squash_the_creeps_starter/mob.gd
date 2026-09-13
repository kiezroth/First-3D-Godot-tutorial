extends CharacterBody3D
# Minimum speed of the mob in meters per second.
@export var min_speed = 10
# Maximum speed of the mob in meters per second.
@export var max_speed = 18

var target_velocity = Vector3.ZERO

signal squashed


func _physics_process(_delta):
	if (target_velocity != Vector3.ZERO):
		velocity = target_velocity
	move_and_slide()
	
func initialize(start_pos, player_pos):
	# Rotate hướng trực tiếp vào player
	player_pos.y = 0
	look_at_from_position(start_pos,player_pos,Vector3.UP)
	# Random angle deg -45 to 45 để không hướng trực tiếp vào player
	rotate_y(randf_range(-PI/4,PI/4))
	
	var random_speed = randi_range(min_speed,max_speed)
	target_velocity = Vector3.FORWARD * random_speed
	# Rotate velocity để move theo hướng đang look 
	target_velocity = target_velocity.rotated(Vector3.UP,rotation.y)

func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	queue_free()

func squash()->void:
	squashed.emit()
	queue_free()
