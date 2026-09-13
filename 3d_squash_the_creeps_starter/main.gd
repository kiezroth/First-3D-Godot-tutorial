extends Node
@export var mob_scene: PackedScene

func _on_mob_timer_timeout() -> void:
	var mob = mob_scene.instantiate()
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	mob.initialize(mob_spawn_location.position,$Player.position)
	add_child(mob)
	mob.squashed.connect($UserInterface/ScoreLabel._on_mob_squashed)

func _on_player_hit() -> void:
	$MobTimer.stop()
	$UserInterface/Retry.show()
	
func _ready() -> void:
	$UserInterface/Retry.hide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible:
		get_tree().reload_current_scene()
