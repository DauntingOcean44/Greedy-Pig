extends Node

#Game Variables
var matchCurr

#What player has, and has to make
var quotaCurr
var quotaMax

#Turn player has, and max amount
var turnCurr
var turnMax

#Indexes 0, 2, and 4 represent the wager, while 1, 3, 5 represent the amount
var vetoArray = [0, 0, 0, 0, 0, 0]

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
		"VetoC": [5, 13]
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
		"VetoC": [4, 9]
	}
}

#Randomly picks veto based on weight
func _random_weighted(array):
	var totalWeight = array[1] + array[3] + array[5]
	var randomIndex = ceil(randf_range(1, totalWeight))
	var currIndex = 0
	var vetoData
		
	print ("weight: " + str(totalWeight))
	if totalWeight <= 0:
		return "No more vetoes"
		
	currIndex += vetoArray[1]
	if currIndex >= randomIndex:
		vetoData = vetoArray[0]
		array[1] -= 1
		print ("Veto A Chosen")
		return vetoData
	
	
	currIndex += vetoArray[3]
	if currIndex >= randomIndex:
		vetoData = vetoArray[2]
		array[3] -= 1
		print ("Veto B Chosen")
		return vetoData
		
	currIndex += vetoArray[5]
	if currIndex >= randomIndex:
		vetoData = vetoArray[4]
		array[5] -= 1
		print ("Veto C Chosen")
		return vetoData
		
			

#When the game is reset / opened
func _menu_screen():
	$MenuHUD.show()
	$ControlHUD.hide()
	matchCurr = 0
	turnCurr = 0
	gameState = 0
	bankCurr = 100
	
#When 'play' is pressed
func _instance_game():
	gameState = 1
	$MenuHUD.hide()
	$ControlHUD.show()
	print("WORKS!")
	
	
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
	
	
	get_node("ControlHUD")._assign_wagers(wagerA, wagerB, wagerC)
	
	
func _update_round_display():
	get_node("ControlHUD/Control/TurnLabel").text = "   Turn: " + str(turnCurr) + "/" + str(turnMax)
	get_node("ControlHUD/Control/QuotaLabel").text = "   Quota: $" + str(quotaCurr) + "/$" + str(quotaMax)
	get_node("ControlHUD/Control/MoneyLabel").text = "   Money: $" + str(bankCurr)
	get_node("ControlHUD/Control/CommitTable/Outcome").text = ""
	get_node("ControlHUD/Control/CommitTable/WagerChoice").text = "Wager: "
	get_node("ControlHUD/Control/CommitTable/VetoChoice").text = "Veto: "
	

func _cast_wager(amount):
	get_node("ControlHUD/Control/CommitTable/WagerChoice").text = "Wager: $" + str(amount)
	chosenWager = amount
	$VetoDelay.start()
	
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
		get_node("ControlHUD/Control/CommitTable/Outcome").text = "Fail"
	else:
		get_node("ControlHUD/Control/CommitTable/Outcome").text = "Success"
		quotaCurr += chosenWager
	$RoundDelay.start()
	

func _on_round_delay_timeout():
	if turnCurr >= turnMax:
		bankCurr += quotaCurr - quotaMax
		matchCurr += 1
		_next_match(gameDict["Match" + str(matchCurr)])
		
	turnCurr += 1
		
	get_node("ControlHUD/Control/WagerContainer/WagerA").disabled = false
	get_node("ControlHUD/Control/WagerContainer/WagerB").disabled = false
	get_node("ControlHUD/Control/WagerContainer/WagerC").disabled = false
	_update_round_display()
	
	
	
