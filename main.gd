extends Node

#Game Variables
var matchCurr
@export var matchMax = 10

#What player has, and has to make
var quotaCurr
var quotaMax

#Turn player has, and max amount
var turnCurr
var turnMax

#Indexes 0, 2, and 4 represent the wager, while 1, 3, 5 represent the amount
var vetoArray = [0, 0, 0, 0, 0, 0]

var contextCurr
var contextArray = []

#Saved values of each wager per match
var wagerA
var wagerB
var wagerC

#The current chosen wager for that round
var chosenWager

#The current chosen veto for that round
var chosenVeto

#Player's bank money
var bankCurr

var gameState


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	matchCurr = 1
	_menu_screen()
	
	matchCurr = 1
	_next_match(gameDict["Match" + str(matchCurr)])
	
	
#Level information dictionary
var gameDict = {
	"Match1": {
		"Quota": 30,
		"Turns": 20,
		
		"WagerA": 1,
		"WagerB": 3,
		"WagerC": 5,
		
		#First value is the wager, second value is the number of that wager
		"VetoA": [1, 0],
		"VetoB": [3, 7],
		"VetoC": [5, 13],
		
		"Context": ["Lets play a little game.", "There are " + str(matchMax) + " matches.", "And a certain amount of turns per match.", "Each Match has a quota. If you fall short, you pay out of pocket to cover the difference. If you exceed the quota, I add that money to your account.", "That quota can be reached by choosing a wager.", "Successful wagers are added to the quota.", "Vetoed wagers are not.", "Whenever you choose a wager, I choose a veto. Neither of us will know what the other picked.", "It's all chance.\n...Predictable chance.", "I have a fixed amount of vetoes to choose from. In my hat, of course.", "Each veto has a set chance of occuring.", "Veto CHANCES:\n$1 | 0%\n$3 | 35%\n$5 | 65%"]
	},
	"Match2": {
		"Quota": 33,
		"Turns": 18,
		
		"WagerA": 2,
		"WagerB": 3,
		"WagerC": 4,
		
		#First value is the wager, second value is the number of that wager
		"VetoA": [2, 3],
		"VetoB": [3, 6],
		"VetoC": [4, 9],
		
		"Context": ["It's only going to get more challenging from here.", "Veto CHANCES:\n$2 | 17%\n$3 | 34%\n$4 | 50%"]
	}
}

#Randomly picks veto based on weight
func _random_weighted(array):
	var totalWeight = array[1] + array[3] + array[5]
	var randomIndex = ceil(randf_range(1, totalWeight))
	var currIndex = 0
	var vetoData
		
	if totalWeight <= 0:
		return "No more vetoes"
		
	currIndex += vetoArray[1]
	if currIndex >= randomIndex:
		vetoData = vetoArray[0]
		#array[1] -= 1
		return vetoData
	
	
	currIndex += vetoArray[3]
	if currIndex >= randomIndex:
		vetoData = vetoArray[2]
		#array[3] -= 1
		return vetoData
		
	currIndex += vetoArray[5]
	if currIndex >= randomIndex:
		vetoData = vetoArray[4]
		#array[5] -= 1
		return vetoData
		
			

#When the game is reset / opened
func _menu_screen():
	$MenuHUD.show()
	$ControlHUD.hide()
	$ControlHUD/DealerLayer.hide()
	$TransitionHUD.hide()
	matchCurr = 0
	turnCurr = 0
	gameState = 0
	bankCurr = 100
	
#When 'play' is pressed
func _instance_game():
	gameState = 1
	$MenuHUD.hide()
	$TransitionHUD.show()
	_update_context_display()
	
	
#When the next match occurs
func _next_match(dictCurr):
	quotaCurr = 0
	turnCurr = 1
	vetoArray[0] = dictCurr["VetoA"][0]
	vetoArray[1] = dictCurr["VetoA"][1]
	vetoArray[2] = dictCurr["VetoB"][0]
	vetoArray[3] = dictCurr["VetoB"][1]
	vetoArray[4] = dictCurr["VetoC"][0]
	vetoArray[5] = dictCurr["VetoC"][1]
	
	wagerA = dictCurr["WagerA"]
	wagerB = dictCurr["WagerB"]
	wagerC = dictCurr["WagerC"]
	quotaMax = dictCurr["Quota"]
	turnMax = dictCurr["Turns"]
	
	contextCurr = 0
	contextArray.clear()
	for i in range(dictCurr["Context"].size()):
		contextArray.append(dictCurr["Context"][i])
	
	get_node("ControlHUD")._assign_wagers(wagerA, wagerB, wagerC)
	
	
func _update_round_display():
	get_node("ControlHUD/Control/TurnLabel").text = "   Turn: " + str(turnCurr) + "/" + str(turnMax)
	get_node("ControlHUD/Control/MatchLabel").text = "   Match: " + str(matchCurr) + "/" + str(matchMax)
	get_node("ControlHUD/Control/QuotaLabel").text = "   Quota: $" + str(quotaCurr) + "/$" + str(quotaMax)
	get_node("ControlHUD/Control/MoneyLabel").text = "   Money: $" + str(bankCurr)
	get_node("ControlHUD/Control/CommitTable/Outcome").text = ""
	get_node("ControlHUD/Control/CommitTable/WagerChoice").text = "Wager: "
	get_node("ControlHUD/Control/CommitTable/VetoChoice").text = "Veto: "
	
	
func _update_context_display():
	get_node("TransitionHUD/Control/VBoxContainer/MatchLabel").text = "Match: " + str(matchCurr) + "/" + str(matchMax)
	get_node("TransitionHUD/Control/VBoxContainer/HBoxContainer/MoneyLabel").text = "Money: $" + str(bankCurr)
	get_node("TransitionHUD/Control/VBoxContainer/HBoxContainer/QuotaLabel").text = "Quota: $" + str(quotaMax)
	get_node("TransitionHUD/Control/VBoxContainer/HBoxContainer/TurnLabel").text = "Turns: " + str(turnMax)
	
	#Button
	if contextCurr != contextArray.size() - 1:
		get_node("TransitionHUD/Control/VBoxContainer/PanelContainer/Panel/StartMatchButton").text = "Next"
	else:
		get_node("TransitionHUD/Control/VBoxContainer/PanelContainer/Panel/StartMatchButton").text = "Start Match"
		
		
	#Text
	get_node("TransitionHUD/Control/VBoxContainer/PanelContainer/Panel/MatchContext").text = contextArray[contextCurr]
	
	

func _cast_wager(amount):
	get_node("ControlHUD/Control/CommitTable/WagerChoice").text = "Wager: $" + str(amount)
	chosenWager = amount
	$VetoDelay.start()
	
func _press_match_button():
	contextCurr += 1
	#Start match when all text is read
	if contextCurr == contextArray.size():
		$ControlHUD.show()
		$ControlHUD/DealerLayer.show()
		$TransitionHUD.hide()
	else:
		_update_context_display()
	
	
func _cast_veto(returnedVeto):
	get_node("ControlHUD/Control/CommitTable/VetoChoice").text = "Veto: $" + str(returnedVeto)
	chosenVeto = returnedVeto
	$CompareDelay.start()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_veto_delay_timeout():
	_cast_veto(_random_weighted(vetoArray))
	$CompareDelay.start()
	

func _on_compare_delay_timeout():
	if chosenVeto == chosenWager:
		
		#Color effect
		var tween = get_tree().create_tween()
		var sprite = $ControlHUD/Control/CommitTable/Outcome
		tween.tween_property(sprite, "modulate", Color.CRIMSON, 0)
		tween.tween_property(sprite, "modulate", Color.WHITE, 0.5)
		get_node("ControlHUD/Control/CommitTable/Outcome").text = "Fail"
	else:
		var tween2 = get_tree().create_tween()
		var sprite2 = $ControlHUD/Control/CommitTable/Outcome
		tween2.tween_property(sprite2, "modulate", Color.PALE_GREEN, 0)
		tween2.tween_property(sprite2, "modulate", Color.WHITE, 0.5)
		get_node("ControlHUD/Control/CommitTable/Outcome").text = "Success"
		quotaCurr += chosenWager
		
		#Color effect
		var tween = get_tree().create_tween()
		var sprite = $ControlHUD/Control/QuotaLabel
		tween.tween_property(sprite, "modulate", Color.PALE_GREEN, 0)
		tween.tween_property(sprite, "modulate", Color.WHITE, 0.5)
	$RoundDelay.start()
	

func _on_round_delay_timeout():
	turnCurr += 1
	if turnCurr > turnMax:
		bankCurr += quotaCurr - quotaMax
		matchCurr += 1
		_next_match(gameDict["Match" + str(matchCurr)])
		_update_context_display()
		$ControlHUD.hide()
		$ControlHUD/DealerLayer.hide()
		$ControlHUD/DealerLayer.hide()
		$TransitionHUD.show()
		
		
	get_node("ControlHUD/Control/WagerContainer/WagerA").disabled = false
	get_node("ControlHUD/Control/WagerContainer/WagerB").disabled = false
	get_node("ControlHUD/Control/WagerContainer/WagerC").disabled = false
	_update_round_display()
	
	
	
