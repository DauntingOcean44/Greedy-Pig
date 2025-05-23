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
	_menu_screen()
	
	
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
	},
	"Match3": {
		"Quota": 40,
		"Turns": 17,
		
		"WagerA": 1,
		"WagerB": 2,
		"WagerC": 8,
		
		#First value is the wager, second value is the number of that wager
		"VetoA": [1, 1],
		"VetoB": [2, 4],
		"VetoC": [8, 15], #Total 20
		
		"Context": ["Will you go big or go home?", "Veto CHANCES:\n$1 | 5%\n$2 | 20%\n$8 | 75%"]
	},
	"Match4": {
		"Quota": 50,
		"Turns": 15,
		
		"WagerA": 0,
		"WagerB": 5,
		"WagerC": 25,
		
		#First value is the wager, second value is the number of that wager
		"VetoA": [0, 0],
		"VetoB": [5, 1],
		"VetoC": [25, 8], #Total 9
		
		"Context": ["I suggest you pick $0 every time...", "Veto CHANCES:\n$0 | 0%\n$5 | 11%\n$25 | 89%"]
	},
	"Match5": {
		"Quota": 60,
		"Turns": 13,
		
		"WagerA": 5,
		"WagerB": 10,
		"WagerC": 15,
		
		#First value is the wager, second value is the number of that wager
		"VetoA": [5, 25],
		"VetoB": [10, 50],
		"VetoC": [15, 75], #Total 150
		
		"Context": ["Do you prefer consistency or getting lucky?", "Veto CHANCES:\n$5 | 16%\n$10 | 34%\n$15 | 50%"]
	},
	"Match6": {
		"Quota": 180,
		"Turns": 10,
		
		"WagerA": 13,
		"WagerB": 14,
		"WagerC": 90,
		
		#First value is the wager, second value is the number of that wager
		"VetoA": [13, 3],
		"VetoB": [14, 4],
		"VetoC": [90, 70], #Total 77
		
		"Context": ["The chances of getting $90 at least once is actually 61%.", "Veto CHANCES:\n$13 | 4%\n$14 | 5%\n$90 | 91%"]
	},
	"Match7": {
		"Quota": 200,
		"Turns": 7,
		
		"WagerA": 20,
		"WagerB": 30,
		"WagerC": 300,
		
		#First value is the wager, second value is the number of that wager
		"VetoA": [20, 1],
		"VetoB": [30, 2],
		"VetoC": [300, 20], #Total 23
		
		"Context": ["If you opt to pick the jackpot option every single time, you've got a 62% of bringing it home. That also means you have a 38% of losing on the spot.", "Veto CHANCES:\n$20 | 4%\n$30 | 9%\n$300 | 87%"]
	},
	"Match8": {
		"Quota": 300,
		"Turns": 5,
		
		"WagerA": 30,
		"WagerB": 40,
		"WagerC": 100,
		
		#First value is the wager, second value is the number of that wager
		"VetoA": [30, 10],
		"VetoB": [40, 15],
		"VetoC": [100, 60], #Total 85
		
		"Context": ["You could play its safe. It would certainly be a net loss, but, if you've got the money to spare, why not?", "Veto CHANCES:\n$30 | 12%\n$40 | 18%\n$100 | 70%"]
	},
	"Match9": {
		"Quota": 1000,
		"Turns": 25,
		
		"WagerA": 4,
		"WagerB": 40,
		"WagerC": 400,
		
		#First value is the wager, second value is the number of that wager
		"VetoA": [4, 0],
		"VetoB": [40, 1],
		"VetoC": [400, 9], #Total 10
		
		"Context": ["Thing's aren't looking too good, now are they? At least you made it this far.","Alright. I'll throw you a bone. You'll need it for the final round...", "Veto CHANCES:\n$4 | 0%\n$40 | 10%\n$400 | 90%"]
	},
	"Match10": {
		"Quota": 10000,
		"Turns": 1,
		
		"WagerA": 9800,
		"WagerB": 9950,
		"WagerC": 9990,
		
		#First value is the wager, second value is the number of that wager
		"VetoA": [9800, 1],
		"VetoB": [9950, 29],
		"VetoC": [9990, 70], #Total 10
		
		"Context": ["The money you've accumulated will determine how much of a risk you need to take. I'll spell it out for you real simple.","If you have at least $200, go ahead and pick the safest option. You'll be outta cash, but at least you won't owe me.","If you're a little tight, but still got a fifty in your back pocket, the second option'll suit you best.","But, maybe you're all outta luck","Or maybe, you just wanna risk it all.", "Let us seal your fate...", "Veto CHANCES:\n$9800 | 1%\n$9950 | 29%\n$9990 | 70%"]
	}
}

#Randomly picks veto based on weight
func _random_weighted(array):
	var totalWeight = array[1] + array[3] + array[5]
	var randomIndex = ceil(randf_range(0, totalWeight))
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
	$RouletteHud.hide()
	$TrialsHUD.hide()
	$GameOver.hide()
	$Winner.hide()
	quotaCurr = 0
	matchCurr = 1
	turnCurr = 0
	gameState = 0
	bankCurr = 100
	
	_next_match(gameDict["Match" + str(matchCurr)])
	_update_round_display()
	_update_context_display()
	
func _roulette_screen():
	$RouletteHud.show()
	$MenuHUD.hide()
	
func _trials_screen():
	$TrialsHUD.show()
	$MenuHUD.hide()
	
#When 'play' is pressed
func _instance_game():
	gameState = 1
	$MenuHUD.hide()
	$TransitionHUD.show()
	_update_context_display()
	
func _reset_everything():
	_menu_screen()
	
func _toggle_fullscreen():
	var mode := DisplayServer.window_get_mode()
	var is_window: bool = mode != DisplayServer.WINDOW_MODE_FULLSCREEN
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if is_window else DisplayServer.WINDOW_MODE_WINDOWED)
	
func _input(event: InputEvent):
	if event.is_action_pressed("Main Menu"):
		_reset_everything()
	if event.is_action_pressed("Fullscreen"):
		_toggle_fullscreen()
	
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
		get_node("TransitionHUD/Control/VBoxContainer/PanelContainer/Panel/HBoxContainer/StartMatchButton").text = "Next"
	else:
		get_node("TransitionHUD/Control/VBoxContainer/PanelContainer/Panel/HBoxContainer/StartMatchButton").text = "Start Match"
		
		
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
		
func _press_skip_button():
	contextCurr += max(1, contextArray.size() - (contextCurr + 1))
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
	
	#Update money first
	if turnCurr > turnMax and matchCurr < 10:
		bankCurr += quotaCurr - quotaMax
	
	#On round completion
	if turnCurr > turnMax and matchCurr < 10 and bankCurr >= 0:
		matchCurr += 1
		_next_match(gameDict["Match" + str(matchCurr)])
		_update_context_display()
		$ControlHUD.hide()
		$ControlHUD/DealerLayer.hide()
		$TransitionHUD.show()
		
	#If the player runs outta cash
	elif bankCurr < 0:
		$ControlHUD.hide()
		$ControlHUD/DealerLayer.hide()
		$GameOver.show()
		
	elif bankCurr >= 0 and turnCurr > turnMax and matchCurr >= 10:
		$ControlHUD.hide()
		$ControlHUD/DealerLayer.hide()
		$Winner.show()
		
		
		
	get_node("ControlHUD/Control/WagerContainer/WagerA").disabled = false
	get_node("ControlHUD/Control/WagerContainer/WagerB").disabled = false
	get_node("ControlHUD/Control/WagerContainer/WagerC").disabled = false
	_update_round_display()
	
	
	
