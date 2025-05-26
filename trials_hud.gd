extends CanvasLayer

#Match data
var maxWagers
var quota
var selectedTab

#Currently selected amount of each wager
var numWagerArray = []

#The locked & unlocked sliders
var scrollDict = {
	"sliderA": 0,
	"sliderB": 0,
	"sliderC": 0
}

#The value of each wager (and also the veto)
var valueWagerA
var valueWagerB
var valueWagerC

#The probability (as a weight) of each veto
var vetoWeightA
var vetoWeightB
var vetoWeightC

#Lock toggles
var toggleA = true
var toggleB = true
var toggleC = true

#Identical to the information found in the main data dictionary
var dataDict

#Declaring paths, and which of the 10 screens to edit
var relevantScreen
var pathValueA = "CenterContainer/PanelContainer/HBoxContainer/Control/CenterContainer/VBoxContainer/PanelContainer/VBoxContainer/CenterContainer/PanelContainer/GridContainer/Value1"
var pathValueB = "CenterContainer/PanelContainer/HBoxContainer/Control/CenterContainer/VBoxContainer/PanelContainer/VBoxContainer/CenterContainer/PanelContainer/GridContainer/Value2"
var pathValueC = "CenterContainer/PanelContainer/HBoxContainer/Control/CenterContainer/VBoxContainer/PanelContainer/VBoxContainer/CenterContainer/PanelContainer/GridContainer/Value3"

var pathSliderMoneyA = "CenterContainer/PanelContainer/HBoxContainer/Control/CenterContainer/VBoxContainer/PanelContainer2/VBoxContainer/PanelContainerA/VBoxContainer/HBoxContainer/Money"
var pathSliderMoneyB = "CenterContainer/PanelContainer/HBoxContainer/Control/CenterContainer/VBoxContainer/PanelContainer2/VBoxContainer/PanelContainerB/VBoxContainer/HBoxContainer/Money"
var pathSliderMoneyC = "CenterContainer/PanelContainer/HBoxContainer/Control/CenterContainer/VBoxContainer/PanelContainer2/VBoxContainer/PanelContainerC/VBoxContainer/HBoxContainer/Money"

var pathChanceA = "CenterContainer/PanelContainer/HBoxContainer/Control/CenterContainer/VBoxContainer/PanelContainer/VBoxContainer/CenterContainer/PanelContainer/GridContainer/Chance1"
var pathChanceB = "CenterContainer/PanelContainer/HBoxContainer/Control/CenterContainer/VBoxContainer/PanelContainer/VBoxContainer/CenterContainer/PanelContainer/GridContainer/Chance2"
var pathChanceC = "CenterContainer/PanelContainer/HBoxContainer/Control/CenterContainer/VBoxContainer/PanelContainer/VBoxContainer/CenterContainer/PanelContainer/GridContainer/Chance3"

var pathSliderA = "CenterContainer/PanelContainer/HBoxContainer/Control/CenterContainer/VBoxContainer/PanelContainer2/VBoxContainer/PanelContainerA/VBoxContainer/HBoxContainer/Panel/WagerSlider"
var pathSliderB = "CenterContainer/PanelContainer/HBoxContainer/Control/CenterContainer/VBoxContainer/PanelContainer2/VBoxContainer/PanelContainerB/VBoxContainer/HBoxContainer/Panel/WagerSlider"
var pathSliderC = "CenterContainer/PanelContainer/HBoxContainer/Control/CenterContainer/VBoxContainer/PanelContainer2/VBoxContainer/PanelContainerC/VBoxContainer/HBoxContainer/Panel/WagerSlider"

var pathSliderAmountA = "CenterContainer/PanelContainer/HBoxContainer/Control/CenterContainer/VBoxContainer/PanelContainer2/VBoxContainer/PanelContainerA/VBoxContainer/HBoxContainer/Amount"
var pathSliderAmountB = "CenterContainer/PanelContainer/HBoxContainer/Control/CenterContainer/VBoxContainer/PanelContainer2/VBoxContainer/PanelContainerB/VBoxContainer/HBoxContainer/Amount"
var pathSliderAmountC = "CenterContainer/PanelContainer/HBoxContainer/Control/CenterContainer/VBoxContainer/PanelContainer2/VBoxContainer/PanelContainerC/VBoxContainer/HBoxContainer/Amount"

var pathLockToggleA = "CenterContainer/PanelContainer/HBoxContainer/Control/CenterContainer/VBoxContainer/PanelContainer2/VBoxContainer/PanelContainerA/VBoxContainer/HBoxContainer/Panel/LockToggle"
var pathLockToggleB = "CenterContainer/PanelContainer/HBoxContainer/Control/CenterContainer/VBoxContainer/PanelContainer2/VBoxContainer/PanelContainerB/VBoxContainer/HBoxContainer/Panel/LockToggle"
var pathLockToggleC = "CenterContainer/PanelContainer/HBoxContainer/Control/CenterContainer/VBoxContainer/PanelContainer2/VBoxContainer/PanelContainerC/VBoxContainer/HBoxContainer/Panel/LockToggle"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass	
	
func _get_data(getDataDict):
	dataDict = getDataDict
	_pull_match_data(0)
	_update_display()
	_reset_sliders()
	
#Upon switching tabs
func _on_tab_container_tab_clicked(tab: int):
	_pull_match_data(tab)
	_update_display()
	_reset_sliders()


func _reset_sliders():
	scrollDict["sliderA"] = numWagerArray[0]
	scrollDict["sliderB"] = numWagerArray[1]
	scrollDict["sliderC"] = numWagerArray[2]
	
	if !toggleA:
		_toggle_slider_A()
	if !toggleB:
		_toggle_slider_B()
	if !toggleC:
		_toggle_slider_C()

#Pull tab data
func _pull_match_data(tab):
	selectedTab = tab
	var indexTab = "Match" + str(tab + 1)
	quota = dataDict[indexTab]["Quota"]
	maxWagers = dataDict[indexTab]["Turns"]
	
	#Setting the values
	valueWagerA = dataDict[indexTab]["WagerA"]
	valueWagerB = dataDict[indexTab]["WagerB"]
	valueWagerC = dataDict[indexTab]["WagerC"]
	
	vetoWeightA = dataDict[indexTab]["VetoA"][1]
	vetoWeightB = dataDict[indexTab]["VetoB"][1]
	vetoWeightC = dataDict[indexTab]["VetoC"][1]
	
	#Setting the default values for the slider
	numWagerArray.clear()
	for i in range(3):
		numWagerArray.append(maxWagers / 3)
	
	#Equally applying the remainder
	var numWagerRemainder = maxWagers % 3
	
	for i in range(numWagerRemainder):
		numWagerArray[i % 3] += 1
	
	
func _toggle_slider_A():
	if toggleA:
		toggleA = false
		relevantScreen.get_node(pathSliderA).editable = false
		relevantScreen.get_node(pathLockToggleA).icon = load("res://sprites/locked.png")
		scrollDict["sliderA"] = 0
	else:
		toggleA = true
		relevantScreen.get_node(pathSliderA).editable = true
		relevantScreen.get_node(pathLockToggleA).icon = load("res://sprites/unlocked.png")
		scrollDict["sliderA"] = numWagerArray[0]
		
func _toggle_slider_B():
	if toggleB:
		toggleB = false
		relevantScreen.get_node(pathSliderB).editable = false
		relevantScreen.get_node(pathLockToggleB).icon = load("res://sprites/locked.png")
		scrollDict["sliderB"] = 0
	else:
		toggleB = true
		relevantScreen.get_node(pathSliderB).editable = true
		relevantScreen.get_node(pathLockToggleB).icon = load("res://sprites/unlocked.png")
		scrollDict["sliderB"] = numWagerArray[0]
		
func _toggle_slider_C():
	if toggleC:
		toggleC = false
		relevantScreen.get_node(pathSliderC).editable = false
		relevantScreen.get_node(pathLockToggleC).icon = load("res://sprites/locked.png")
		scrollDict["sliderC"] = 0
	else:
		toggleC = true
		relevantScreen.get_node(pathSliderC).editable = true
		relevantScreen.get_node(pathLockToggleC).icon = load("res://sprites/unlocked.png")
		scrollDict["sliderC"] = numWagerArray[0]
	
	
func _update_display():
	
	#Updating relevant screen (there are 10, this chooses the one being displayed)
	relevantScreen = $Control/TabContainer.get_child(selectedTab).get_child(0)
	
	relevantScreen.get_node(pathValueA).text = "$" + str(valueWagerA)
	relevantScreen.get_node(pathValueB).text = "$" + str(valueWagerB)
	relevantScreen.get_node(pathValueC).text = "$" + str(valueWagerC)
	
	relevantScreen.get_node(pathSliderMoneyA).text = "$" + str(valueWagerA)
	relevantScreen.get_node(pathSliderMoneyB).text = "$" + str(valueWagerB)
	relevantScreen.get_node(pathSliderMoneyC).text = "$" + str(valueWagerC)
	
	relevantScreen.get_node(pathSliderAmountA).text = str(numWagerArray[0]) + "x"
	relevantScreen.get_node(pathSliderAmountB).text = str(numWagerArray[1]) + "x"
	relevantScreen.get_node(pathSliderAmountC).text = str(numWagerArray[2]) + "x"
	
	relevantScreen.get_node(pathSliderA).max_value = maxWagers
	relevantScreen.get_node(pathSliderB).max_value = maxWagers
	relevantScreen.get_node(pathSliderC).max_value = maxWagers
	
	relevantScreen.get_node(pathSliderA).value = numWagerArray[0]
	relevantScreen.get_node(pathSliderB).value = numWagerArray[1]
	relevantScreen.get_node(pathSliderC).value = numWagerArray[2]
	
	#Probability C has additional math that fills in any inprecision because this is integer based division
	#Basically if A% + B% + C% is less than 100, the remainder will be added to C to ensure the probabiltiies
	#Always add up to 100. Don't try to decipher it, it'll make your head hurt from all the brackets.
	relevantScreen.get_node(pathChanceA).text = str((vetoWeightA * 100) / ((vetoWeightA + vetoWeightB + vetoWeightC) * 1)) + "%"
	relevantScreen.get_node(pathChanceB).text = str((vetoWeightB * 100) / ((vetoWeightA + vetoWeightB + vetoWeightC) * 1)) + "%"
	relevantScreen.get_node(pathChanceC).text = str(((vetoWeightC * 100) / ((vetoWeightA + vetoWeightB + vetoWeightC) * 1) + (100 % ((vetoWeightA * 100) / ((vetoWeightA + vetoWeightB + vetoWeightC) * 1) + (vetoWeightB * 100) / ((vetoWeightA + vetoWeightB + vetoWeightC) * 1) + (vetoWeightC * 100) / ((vetoWeightA + vetoWeightB + vetoWeightC) * 1))))) + "%"
