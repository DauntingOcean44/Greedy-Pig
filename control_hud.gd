extends CanvasLayer

var wagerA
var wagerB
var wagerC 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _chose_wager():
	$Control/WagerContainer/WagerA.disabled = true
	$Control/WagerContainer/WagerB.disabled = true
	$Control/WagerContainer/WagerC.disabled = true
	
func _assign_wagers(A, B, C):
	$Control/WagerContainer/WagerA.text = "$" + str(A)
	$Control/WagerContainer/WagerB.text = "$" + str(B)
	$Control/WagerContainer/WagerC.text = "$" + str(C)
	wagerA = A
	wagerB = B
	wagerC = C
	$Control/WagerContainer/WagerA.disabled = false
	$Control/WagerContainer/WagerB.disabled = false
	$Control/WagerContainer/WagerC.disabled = false

func _on_wager_a_button_up() -> void:
	get_tree().call_group("wager_amount", "_cast_wager", wagerA)
	_chose_wager()


func _on_wager_b_button_up() -> void:
	get_tree().call_group("wager_amount", "_cast_wager", wagerB)
	_chose_wager()
	

func _on_wager_c_button_up() -> void:
	get_tree().call_group("wager_amount", "_cast_wager", wagerC)
	_chose_wager()
