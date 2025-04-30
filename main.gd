extends Node

#Game Variables
var matchCurr

var quotaCurr
var quotaMax

var turnCurr
var turnMax

var vetoArray
var wagerArray

var bankCurr

var gameState


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_menu_screen()
	
	
	
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
	
func _cast_wager(amount):
	print (amount)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
