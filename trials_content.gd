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


func _on_wager_sliderA_drag_ended(value_changed: bool) -> void:
		get_tree().call_group("trials_hud", "_slider_allocation_A")


func _on_wager_sliderB_drag_ended(value_changed: bool) -> void:
	get_tree().call_group("trials_hud", "_slider_allocation_B")


func _on_wager_sliderC_drag_ended(value_changed: bool) -> void:
	get_tree().call_group("trials_hud", "_slider_allocation_C")
