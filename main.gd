extends Node

#Game Variables
var matchCurr

var quotaCurr
var quotaMax

var turnCurr
var turnMax

#Indexes 0, 2, and 4 represent the wager, while 1, 3, 5 represent the amount
var vetoArray = [0, 0, 0, 0, 0, 0]

var wagerA
var wagerB
var wagerC

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
	}
}

func _random_weighted(array):
	var totalWeight = array[1] + array[3] + array[5]
	var randomIndex = ceil(randf_range(1, totalWeight))
	var currIndex = 0
	var vetoData
		
	print ("weight: " + str(totalWeight))
	if totalWeight <= 0:
		$VetoDelay.stop()
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
	
	#Remove after
	$VetoDelay.start()
	
#When the next match occurs
func _next_match(dictCurr):
	quotaCurr = 0
	turnCurr = 0
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

func _cast_wager(amount):
	print (amount)
	get_node("ControlHUD/Control/CommitTable/WagerChoice").text = "Wager: $" + str(amount)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_veto_delay_timeout():
	print(_random_weighted(vetoArray))
