extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
	
func _on_start_game_button_up():
	get_tree().call_group("start_game", "_instance_game")
	

func _on_start_roulette_button_up():
	get_tree().call_group("start_game", "_roulette_screen")


func _on_start_trials_button_up():
	get_tree().call_group("start_game", "_trials_screen")
