extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_lock_toggle_A_button_up() -> void:
	get_tree().call_group("trials_hud", "_toggle_slider_A")

func _on_lock_toggle_B_button_up() -> void:
	get_tree().call_group("trials_hud", "_toggle_slider_B")


func _on_lock_toggle_C_button_up() -> void:
	get_tree().call_group("trials_hud", "_toggle_slider_C")


func _on_wager_sliderA_drag_ended(_value_changed: bool) -> void:
		get_tree().call_group("trials_hud", "distributeSliderA")


func _on_wager_sliderB_drag_ended(_value_changed: bool) -> void:
	get_tree().call_group("trials_hud", "distributeSliderB")


func _on_wager_sliderC_drag_ended(_value_changed: bool) -> void:
	get_tree().call_group("trials_hud", "distributeSliderC")


var pathBinEdit = "CenterContainer/PanelContainer/HBoxContainer/Outcomes/CenterContainer/VBoxContainer2/HBoxContainer2/PanelContainer/VBoxContainer2/HBoxContainer/BinEdit"
func _on_bin_edit_text_submitted(new_text: String) -> void:
	var numtext = int(new_text)
	numtext = clamp(numtext, 1, 10)
	get_node(pathBinEdit).text = str(numtext)
	

var pathTrialsEdit = "CenterContainer/PanelContainer/HBoxContainer/Outcomes/CenterContainer/VBoxContainer2/HBoxContainer2/PanelContainer/VBoxContainer2/VBoxContainer/HBoxContainer/TrialsEdit"
func _on_trials_edit_text_submitted(new_text: String) -> void:
	var numtext = int(new_text)
	numtext = clamp(numtext, 1, 10000)
	get_node(pathTrialsEdit).text = str(numtext)
