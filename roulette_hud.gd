extends CanvasLayer

var displayTable := []
var trialSize = 1000
var SliderNode
var PValue
var EValue
var AmountA
var ToggleButton
var displayPercent = false


# Called when the node enters the scene tree for the first time.
func _ready():
	SliderNode = $PanelContainer/VBoxContainer/ControlBody/CenterContainer/VBoxContainer/PanelContainer2/HBoxContainer/PanelContainer/HBoxContainer/Control/TrialSlider
	PValue = $PanelContainer/VBoxContainer/ControlBody/CenterContainer/VBoxContainer/PanelContainer2/HBoxContainer/VBoxContainer/HBoxContainer/PValue
	EValue = $PanelContainer/VBoxContainer/ControlBody/CenterContainer/VBoxContainer/PanelContainer2/HBoxContainer/VBoxContainer/HBoxContainer2/EValue
	AmountA = $PanelContainer/VBoxContainer/ControlBody/CenterContainer/VBoxContainer/PanelContainer2/HBoxContainer/PanelContainer/HBoxContainer/AmountA
	ToggleButton = $PanelContainer/VBoxContainer/ControlBody/CenterContainer/VBoxContainer/PanelContainer2/HBoxContainer/VBoxContainer2/ToggleButton
	_run_1000_trials()
	_update_other_values()
	_display_values()
	
	_run_1000_trials()
	_update_other_values()
	_display_values()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _run_1000_trials():
	#Initialize the array
	displayTable.clear()
	
	displayTable.append(["00", 0, 0.0])
	for i in range(37):
		displayTable.append([str(i), 0, 0.0])
		
	#Run set amount of trials
	for i in range(trialSize):
		var index = floor(randf_range(0, 38))
		displayTable[index][1] += 1
	
	#Calculate the probability for each trial
	for i in range($PanelContainer/VBoxContainer/ControlBody/CenterContainer/VBoxContainer/PanelContainer/GridContainer.get_child_count()):
		#var child = $PanelContainer/VBoxContainer/ControlBody/CenterContainer/VBoxContainer/PanelContainer/GridContainer.get_child(i)
		var probability = displayTable[i][1] / trialSize
		probability *= 100
		probability = snapped(float(probability), float(0.01))
		displayTable[i][2] = probability
	
	_update_other_values()
	_display_values()
	
func _toggle_display():
	if !displayPercent:
		displayPercent = true
	else:
		displayPercent = false
		
	if displayPercent:
		ToggleButton.text = "Toggle x"
	else:
		ToggleButton.text = "Toggle %"
		
	_display_values()
		
	
		
		

func _display_values():
	for i in range($PanelContainer/VBoxContainer/ControlBody/CenterContainer/VBoxContainer/PanelContainer/GridContainer.get_child_count()):
		var child = $PanelContainer/VBoxContainer/ControlBody/CenterContainer/VBoxContainer/PanelContainer/GridContainer.get_child(i)
		if !displayPercent:
			child.text = str(displayTable[i][0]) + ": " + str(displayTable[i][1]) + "x"
		else:
			child.text = str(displayTable[i][0]) + ": " + str(displayTable[i][2]) + "%"
	
	
func _update_other_values():
	trialSize = SliderNode.value
	var floatA := 0.0
	
	floatA = float(1) / float(38)
	floatA = snapped(floatA, 0.0001)
	floatA *= 100
	PValue.text = str(floatA) + "%"

	
	var floatB : float = 0.0
	floatB = float(floatA) * float(trialSize) / float(100)
	floatB = snapped(float(floatB), 0.00001)
	EValue.text = str(floatB)
	
	AmountA.text = str(trialSize) + "x"

func _on_trial_slider_drag_ended(_value_changed: bool):
	_update_other_values()
	
	
	
func _on_toggle_button_button_up():
	_toggle_display()


func _on_start_button_button_up():
	_run_1000_trials()
	_update_other_values()
