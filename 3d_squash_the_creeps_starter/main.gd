# Note: di chuyển chéo (deg = 45) thì không thể jump được bằng phím space
# có thể dùng enter để thay thế
extends Node
@export var mob_scene: PackedScene
@onready var base_mob_timer = $MobTimer.wait_time

#Tốc độ mob tăng theo độ khó 
@export_range(1,10) var Difficult_based_on_score = 5
@export var mob_speed_difficult_increasing_per_level  = 1.0
var mob_speed_difficult_modify = 0

func _ready() -> void:
	$Player.hide()
	$UserInterface/Retry.show()
func _on_mob_timer_timeout() -> void:
	
	var mob = mob_scene.instantiate()
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	mob.initialize(mob_spawn_location.position,$Player.position, mob_speed_difficult_modify)
	add_child(mob)
	mob.squashed.connect($UserInterface/ScoreLabel._on_mob_squashed)

func _on_player_hit() -> void:
	
	$MobTimer.stop()
	
	$UserInterface/Retry/Message.text = "Game Over"
	$UserInterface/Retry.show()
	$GameOverTimer.start()
	
	MusicPlayer.stop()
	$GameOverAudio.play()

func _unhandled_input(event: InputEvent) -> void:
	
	if event.is_action_pressed("ui_accept") and $UserInterface/Retry/Button.visible:
		_on_button_pressed()


func _on_button_pressed() -> void:
	
	$UserInterface/Retry/Message.text = "Game Ready"
	$UserInterface/Retry/Button.hide()
	
	MusicPlayer.play()
	
	ResetDifficulty()
	$StartTimer.start()


func _on_start_timer_timeout() -> void:
	
	$UserInterface/Retry.hide()
	$UserInterface/ScoreLabel.ResetScore()
	
	$Player.start($PlayerSpawnLocation.position)
	
	$MobTimer.start()



func _on_game_over_timer_timeout() -> void:
	$UserInterface/Retry/Message.text = "Squash the Creeps"
	$UserInterface/Retry/Button.show()

func ResetDifficulty() -> void:
	$MobTimer.wait_time = base_mob_timer
	mob_speed_difficult_modify = 0
func _on_score_label_difficult_increasing() -> void:
	$MobTimer.wait_time -= 0.1
	mob_speed_difficult_modify += 1
