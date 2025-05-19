extends CanvasLayer

var displayTable := []
var trialSize = 1000
var SliderNode
var PValue
var EValue
var AmountA


# Called when the node enters the scene tree for the first time.
func _ready():
	SliderNode = $PanelContainer/VBoxContainer/ControlBody/CenterContainer/VBoxContainer/PanelContainer2/HBoxContainer/PanelContainer/HBoxContainer/Control/TrialSlider
	PValue = $PanelContainer/VBoxContainer/ControlBody/CenterContainer/VBoxContainer/PanelContainer2/HBoxContainer/VBoxContainer/HBoxContainer/PValue
	EValue = $PanelContainer/VBoxContainer/ControlBody/CenterContainer/VBoxContainer/PanelContainer2/HBoxContainer/VBoxContainer/HBoxContainer2/EValue
	AmountA = $PanelContainer/VBoxContainer/ControlBody/CenterContainer/VBoxContainer/PanelContainer2/HBoxContainer/PanelContainer/HBoxContainer/AmountA
	_run_1000_trials()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_start_button_button_up():
	_run_1000_trials()

func _run_1000_trials():
	#Initialize the array
	displayTable.clear()
	
	displayTable.append(["00", 0])
	for i in range(37):
		displayTable.append([str(i), 0])
		
	#Run set amount of trials
	for i in range(trialSize):
		var index = floor(randf_range(0, 38))
		displayTable[index][1] += 1
	
	for i in range($PanelContainer/VBoxContainer/ControlBody/CenterContainer/VBoxContainer/PanelContainer/GridContainer.get_child_count()):
		var child = $PanelContainer/VBoxContainer/ControlBody/CenterContainer/VBoxContainer/PanelContainer/GridContainer.get_child(i)
		child.text = str(displayTable[i][0]) + ": " + str(displayTable[i][1]) + "x"
	
	
func _update_other_values():
	trialSize = SliderNode.value
	var floatA := 0.0
	
	floatA = float(1) / float(38)
	floatA = snapped(floatA, 0.001)
	floatA *= 100
	PValue.text = str(floatA) + "%"

	
	var floatB := 0.0
	floatB = floatA * trialSize / 100
	floatB = snapped(floatB, 0.001)
	EValue.text = str(floatB)
	
	AmountA.text = str(trialSize) + "x"

func _on_trial_slider_drag_ended(value_changed: bool):
	_update_other_values()
	
	
	
