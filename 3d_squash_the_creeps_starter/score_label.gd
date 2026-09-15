extends Label
## Tăng 1 level với mỗi x điểm, tối đa tăng 4 lv
@onready var Difficult_based_on_score = $"../..".Difficult_based_on_score
var score = 0
signal DifficultIncreasing
func _on_mob_squashed() -> void:

	if  floori( ( score + 1 ) / float(Difficult_based_on_score) ) > floori( ( score / float(Difficult_based_on_score) ) ) && score <= Difficult_based_on_score * 4:
		DifficultIncreasing.emit()
		$LevelLabel.text = "Level: %s" % int((1 + (( score + 1 ) / float(Difficult_based_on_score))))
		#print("up")
	score += 1
	text = "Score: %s" % score
	
func ResetScore():
	score = 0
	text = "Score: %s" % score
	$LevelLabel.text = "Level: %s" % int((1 + (( score + 1 ) / float(Difficult_based_on_score))))
