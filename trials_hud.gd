extends CanvasLayer

#Match data
var maxWagers
var quota
var selectedTab

#Currently selected amount of each wager
var numWagerArray = []

#Simultated array of quotas
var quotaArray = []
var quotaMin = INF
var quotaMax = 0


#The value of each wager (and also the veto)
var valueWagerA
var valueWagerB
var valueWagerC

#The probability (as a weight) of each veto
var vetoWeightA
var vetoWeightB
var vetoWeightC

#Identical to the information found in the main data dictionary
var dataDict

#For graphing & simulation purposes
var binWidth = 0
var trials = 0

#Theoretical calculations
var averageValue: float = 0.0
var averageQuota: float = 0.0

#Theoretical vs experimental probabilities
var experimentalProbability = 0.0
var theoreticalProbability = 0.0

#Declaring paths, and which of the 10 screens to edit
var relevantScreen
var pathValueA = "CenterContainer/PanelContainer/HBoxContainer/Control/ScrollContainer/CenterContainer/VBoxContainer/PanelContainer/VBoxContainer/CenterContainer/PanelContainer/GridContainer/Value1"
var pathValueB = "CenterContainer/PanelContainer/HBoxContainer/Control/ScrollContainer/CenterContainer/VBoxContainer/PanelContainer/VBoxContainer/CenterContainer/PanelContainer/GridContainer/Value2"
var pathValueC = "CenterContainer/PanelContainer/HBoxContainer/Control/ScrollContainer/CenterContainer/VBoxContainer/PanelContainer/VBoxContainer/CenterContainer/PanelContainer/GridContainer/Value3"

var pathSliderMoneyA = "CenterContainer/PanelContainer/HBoxContainer/Control/ScrollContainer/CenterContainer/VBoxContainer/PanelContainer2/VBoxContainer/PanelContainerA/VBoxContainer/HBoxContainer/Money"
var pathSliderMoneyB = "CenterContainer/PanelContainer/HBoxContainer/Control/ScrollContainer/CenterContainer/VBoxContainer/PanelContainer2/VBoxContainer/PanelContainerB/VBoxContainer/HBoxContainer/Money"
var pathSliderMoneyC = "CenterContainer/PanelContainer/HBoxContainer/Control/ScrollContainer/CenterContainer/VBoxContainer/PanelContainer2/VBoxContainer/PanelContainerC/VBoxContainer/HBoxContainer/Money"

var pathChanceA = "CenterContainer/PanelContainer/HBoxContainer/Control/ScrollContainer/CenterContainer/VBoxContainer/PanelContainer/VBoxContainer/CenterContainer/PanelContainer/GridContainer/Chance1"
var pathChanceB = "CenterContainer/PanelContainer/HBoxContainer/Control/ScrollContainer/CenterContainer/VBoxContainer/PanelContainer/VBoxContainer/CenterContainer/PanelContainer/GridContainer/Chance2"
var pathChanceC = "CenterContainer/PanelContainer/HBoxContainer/Control/ScrollContainer/CenterContainer/VBoxContainer/PanelContainer/VBoxContainer/CenterContainer/PanelContainer/GridContainer/Chance3"

var pathSliderA = "CenterContainer/PanelContainer/HBoxContainer/Control/ScrollContainer/CenterContainer/VBoxContainer/PanelContainer2/VBoxContainer/PanelContainerA/VBoxContainer/HBoxContainer/Panel/WagerSlider"
var pathSliderB = "CenterContainer/PanelContainer/HBoxContainer/Control/ScrollContainer/CenterContainer/VBoxContainer/PanelContainer2/VBoxContainer/PanelContainerB/VBoxContainer/HBoxContainer/Panel/WagerSlider"
var pathSliderC = "CenterContainer/PanelContainer/HBoxContainer/Control/ScrollContainer/CenterContainer/VBoxContainer/PanelContainer2/VBoxContainer/PanelContainerC/VBoxContainer/HBoxContainer/Panel/WagerSlider"

var pathSliderAmountA = "CenterContainer/PanelContainer/HBoxContainer/Control/ScrollContainer/CenterContainer/VBoxContainer/PanelContainer2/VBoxContainer/PanelContainerA/VBoxContainer/HBoxContainer/Amount"
var pathSliderAmountB = "CenterContainer/PanelContainer/HBoxContainer/Control/ScrollContainer/CenterContainer/VBoxContainer/PanelContainer2/VBoxContainer/PanelContainerB/VBoxContainer/HBoxContainer/Amount"
var pathSliderAmountC = "CenterContainer/PanelContainer/HBoxContainer/Control/ScrollContainer/CenterContainer/VBoxContainer/PanelContainer2/VBoxContainer/PanelContainerC/VBoxContainer/HBoxContainer/Amount"

var pathLockToggleA = "CenterContainer/PanelContainer/HBoxContainer/Control/ScrollContainer/CenterContainer/VBoxContainer/PanelContainer2/VBoxContainer/PanelContainerA/VBoxContainer/HBoxContainer/Panel/LockToggle"
var pathLockToggleB = "CenterContainer/PanelContainer/HBoxContainer/Control/ScrollContainer/CenterContainer/VBoxContainer/PanelContainer2/VBoxContainer/PanelContainerB/VBoxContainer/HBoxContainer/Panel/LockToggle"
var pathLockToggleC = "CenterContainer/PanelContainer/HBoxContainer/Control/ScrollContainer/CenterContainer/VBoxContainer/PanelContainer2/VBoxContainer/PanelContainerC/VBoxContainer/HBoxContainer/Panel/LockToggle"

var pathQuota = "CenterContainer/PanelContainer/HBoxContainer/Outcomes/CenterContainer/VBoxContainer2/PanelContainer3/VBoxContainer2/HBoxContainer/QuotaAmount"

var pathAverageValue = "CenterContainer/PanelContainer/HBoxContainer/Outcomes/CenterContainer/VBoxContainer2/HBoxContainer2/PanelContainer2/VBoxContainer2/HBoxContainer/AverageValue"
var pathAverageQuota = "CenterContainer/PanelContainer/HBoxContainer/Outcomes/CenterContainer/VBoxContainer2/HBoxContainer2/PanelContainer2/VBoxContainer2/VBoxContainer/HBoxContainer/AverageQuota"

var pathBinWidth = "CenterContainer/PanelContainer/HBoxContainer/Outcomes/CenterContainer/VBoxContainer2/HBoxContainer2/PanelContainer/VBoxContainer2/HBoxContainer/BinEdit"
var pathTrialsAmount = "CenterContainer/PanelContainer/HBoxContainer/Outcomes/CenterContainer/VBoxContainer2/HBoxContainer2/PanelContainer/VBoxContainer2/VBoxContainer/HBoxContainer/TrialsEdit"

var pathExperimentalProbability = "CenterContainer/PanelContainer/HBoxContainer/Control/ScrollContainer/CenterContainer/VBoxContainer/PanelContainer3/VBoxContainer/CenterContainer/PanelContainer/GridContainer/ExperimentalChance"
var pathTheoreticalProbability = "CenterContainer/PanelContainer/HBoxContainer/Control/ScrollContainer/CenterContainer/VBoxContainer/PanelContainer3/VBoxContainer/CenterContainer/PanelContainer/GridContainer/TheoreticalChance"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass	
	
	
func _get_data(getDataDict):
	dataDict = getDataDict
	get_tree().call_group("histogram", "clear_data")
	_pull_match_data(0)
	_pull_line_data(5, "binWidth")
	_pull_line_data(500, "trials")
	_simulate_trials()
	_reset_sliders()
	_calc_averages()
	_update_display()
	
#Upon switching tabs
func _on_tab_container_tab_clicked(tab: int):
	get_tree().call_group("histogram", "clear_data")
	_pull_match_data(tab)
	_pull_line_data(5, "binWidth")
	_pull_line_data(500, "trials")
	_simulate_trials()
	_reset_sliders()
	_calc_averages()
	_update_display()


func _reset_sliders():
	if !numWagerArray[0][1]:
		_toggle_slider_A()
	if !numWagerArray[1][1]:
		_toggle_slider_B()
	if !numWagerArray[2][1]:
		_toggle_slider_C()


func _calc_averages():
	var expectedValA: float
	var expectedValB: float
	var expectedValC: float
	var weightSum = vetoWeightA + vetoWeightB + vetoWeightC

	#Average value calculation
	expectedValA = (valueWagerA * (((weightSum - vetoWeightA)* 100) / weightSum))
	expectedValA /= 100 
	expectedValB = (valueWagerB * (((weightSum - vetoWeightB)* 100) / weightSum))
	expectedValB /= 100 
	expectedValC = (valueWagerC * (((weightSum - vetoWeightC)* 100) / weightSum))
	expectedValC /= 100 
	
	averageValue = (expectedValA * (float(numWagerArray[0][0]) / float(maxWagers))) + (expectedValB * (float(numWagerArray[1][0]) / float(maxWagers))) + (expectedValC * (float(numWagerArray[2][0]) / float(maxWagers)))
	averageQuota = averageValue * maxWagers
	
	averageValue = snapped(averageValue, 0.01) if averageValue < 10 else snapped(averageValue, 0)
	averageQuota = snapped(averageQuota, 0)

func _graph_trials():
	_simulate_trials()
	_update_display()
	
	get_tree().call_group("histogram", "_import_data", binWidth, quotaMin, quotaMax, quotaArray, trials)

func _calc_theoretical_trials():
	var chosenWagerDictList = {"prob": [], "sampleSpace": []}
	var discreteNumWager = []
	var totalWeight = vetoWeightA + vetoWeightB + vetoWeightC
	var iterations = 0
	
	#The actual probability
	var numerator : float = 0.0
	var denominator : float = 0.0
	var fraction : float = 0.0
	
	#numWagerArray holds data in unsuitable format, so must be converted
	for i in range(numWagerArray.size()):
		for j in range(numWagerArray[i][0]):
			if i == 0:
				discreteNumWager.append(valueWagerA)
			if i == 1:
				discreteNumWager.append(valueWagerB)
			if i == 2:
				discreteNumWager.append(valueWagerC)
	
	#Assinging each wager's respective probability of success
	for i in range(discreteNumWager.size()):
		var probSuccess : float = 0.0
		if discreteNumWager[i] == valueWagerA:
			probSuccess = float(1) - (float(vetoWeightA) / float(totalWeight))
			chosenWagerDictList["prob"].append(probSuccess)
		if discreteNumWager[i] == valueWagerB:
			probSuccess = float(1) - (float(vetoWeightB) / float(totalWeight))
			chosenWagerDictList["prob"].append(probSuccess)
		if discreteNumWager[i] == valueWagerC:
			probSuccess = float(1) - (float(vetoWeightC) / float(totalWeight))
			chosenWagerDictList["prob"].append(probSuccess)
	
	#also assigning the 0 variations
	var zeroProbabilityList = []
	for probability in chosenWagerDictList["prob"]:
		var inverse = 1 - probability
		zeroProbabilityList.append(inverse)
		
	chosenWagerDictList["prob"] += zeroProbabilityList
	
	#Creating the sample space
	for i in range(discreteNumWager.size()):
		chosenWagerDictList["sampleSpace"].append(discreteNumWager[i])
		
	for i in range(discreteNumWager.size()):
		chosenWagerDictList["sampleSpace"].append(0)
		
	#Running through all the combinations
	var indices = []
	for i in range(maxWagers):
		indices.append(i)
		
	#Main loop
	
	while true:
		var wagerCombination = []
		var summation: int = 0
		var probabilityProduct: float = 1.0
		
		#Generating the combination
		for i in indices:
			wagerCombination.append(chosenWagerDictList["sampleSpace"][i])
		iterations += 1
			
		#Running the quota comparisons & weightings
		for i in range(wagerCombination.size()):
			summation += wagerCombination[i]
			probabilityProduct *= chosenWagerDictList["prob"][indices[i]]
			
		if summation >= quota:
			numerator += probabilityProduct
			
		denominator += probabilityProduct
		
		
		#Finding the rightmost value in the wagerCombination that can be incrimented
		var pos = maxWagers - 1
		while pos >= 0 and indices[pos] == (maxWagers * 2) - maxWagers + pos:
			pos -= 1
			
		#If no pos can be incrimented, all combinations have been looked through
		if pos < 0:
			break
				
		#Incriment the found index
		indices[pos] += 1
		
		#Reset all indices to right of pos
		for j in range(pos + 1, maxWagers):
			indices[j] = indices[pos] + (j - pos)
		
	fraction = numerator / denominator
	fraction *= 100
	

func _simulate_trials():
	quotaArray.clear()
	quotaMin = INF
	quotaMax = 0
	
	#of trials that meet or exceed the quota
	var successfulTrials = 0
	
	#Creating an array of the selected values
	var chosenWagerDictArray = []
	
	#Used in randf-range success simulator
	var totalWeight = vetoWeightA + vetoWeightB + vetoWeightC
	
	#Looping through the numWagerArray to create data
	for i in range(numWagerArray[0][0]):
		chosenWagerDictArray.append({"wager": valueWagerA, "success": totalWeight - vetoWeightA})
		
	for i in range(numWagerArray[1][0]):
		chosenWagerDictArray.append({"wager": valueWagerB, "success": totalWeight - vetoWeightB})
		
	for i in range(numWagerArray[2][0]):
		chosenWagerDictArray.append({"wager": valueWagerC, "success": totalWeight - vetoWeightC})
		
	#Main trials loop
	for i in range(trials):
		
		#Where the successful wagers indices will be recorded
		var successArray = []
		var trialQuota = 0
		
		#Single match loop
		for j in range(maxWagers):
			var randInt = floor(randf_range(1, totalWeight + 1))
			
			#Recording the indice of a successful wager
			if chosenWagerDictArray[j]["success"] >= randInt:
				successArray.append(j)
				
		for j in range(successArray.size()):
			trialQuota += chosenWagerDictArray[successArray[j]]["wager"]
		
		#Setting the histogram's min and max
		quotaMin = min(quotaMin, trialQuota)
		quotaMax = max(quotaMax, trialQuota)
		
		#Counting successful quotas
		successfulTrials += 1 if trialQuota >= quota else 0
		quotaArray.append(float(trialQuota)) 
		
	#Calculating experimental probability
	experimentalProbability = float(successfulTrials) / float(trials)
	experimentalProbability *= 100
	experimentalProbability = snapped(experimentalProbability, 0.01) if experimentalProbability < 10 else snapped(experimentalProbability, 0)
		
	#print(quotaArray)
	#print(chosenWagerDictArray)

#Update data from text input
func _pull_line_data(value, source):
	if source == "binWidth":
		binWidth = value
	elif source == "trials":
		trials = value

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
		numWagerArray.append([maxWagers / 3, true])
	
	#Equally applying the remainder
	var numWagerRemainder = maxWagers % 3
	
	for i in range(numWagerRemainder):
		numWagerArray[i % 3][0] += 1
	
	
	
	
func _toggle_slider_A():
	if numWagerArray[0][1]:
		numWagerArray[0][1] = false
		relevantScreen.get_node(pathSliderA).editable = false
		relevantScreen.get_node(pathLockToggleA).icon = load("res://sprites/locked.png")
	else:
		numWagerArray[0][1] = true
		relevantScreen.get_node(pathSliderA).editable = true
		relevantScreen.get_node(pathLockToggleA).icon = load("res://sprites/unlocked.png")
		
func _toggle_slider_B():
	if numWagerArray[1][1]:
		numWagerArray[1][1] = false
		relevantScreen.get_node(pathSliderB).editable = false
		relevantScreen.get_node(pathLockToggleB).icon = load("res://sprites/locked.png")
	else:
		numWagerArray[1][1] = true
		relevantScreen.get_node(pathSliderB).editable = true
		relevantScreen.get_node(pathLockToggleB).icon = load("res://sprites/unlocked.png")
		
func _toggle_slider_C():
	if numWagerArray[2][1]:
		numWagerArray[2][1] = false
		relevantScreen.get_node(pathSliderC).editable = false
		relevantScreen.get_node(pathLockToggleC).icon = load("res://sprites/locked.png")
	else:
		numWagerArray[2][1] = true
		relevantScreen.get_node(pathSliderC).editable = true
		relevantScreen.get_node(pathLockToggleC).icon = load("res://sprites/unlocked.png")
	
	
func distributeSliderA():
	#How much the slider can be moved up or down by
	var incrimentalSlideAllowance = 0
	var decrementalSlideAllowance = 0
	
	#Storing the availables seperately
	var availableSlidersArray = []
	availableSlidersArray.clear()
	
	#Creating the availableSlidersArray
	for i in range(numWagerArray.size()):
		if i != 0 && numWagerArray[i][1] == true:
			availableSlidersArray.append(numWagerArray[i])
	
	
	#The requested change by the user
	var difference = relevantScreen.get_node(pathSliderA).value - numWagerArray[0][0]
	
	#Add up the values from the other sliders to determine how much the selected slider can use
	for i in range(availableSlidersArray.size()):
		if availableSlidersArray[i][1]:
			incrimentalSlideAllowance += availableSlidersArray[i][0]
			
			
	#Add up how much the other sliders can be incrimented by
	for i in range(availableSlidersArray.size()):
		if availableSlidersArray[i][1]:
			decrementalSlideAllowance += maxWagers - availableSlidersArray[i][0]
			
	#The minimum between how much the sliders can be incrimented
	#And also how much the selected slider has to give
	decrementalSlideAllowance = min(decrementalSlideAllowance, numWagerArray[0][0])
	decrementalSlideAllowance = -decrementalSlideAllowance
	
	
	#Ensuring the slider is moved within a legal limit
	var clampedDifference = clamp(difference, decrementalSlideAllowance, incrimentalSlideAllowance)
	
	#The inverse must be applied to the OTHER sliders
	var inverseClampedDifference = -clampedDifference
	#And we can't forget about the remainder...
	
	if availableSlidersArray:
		#var remainderInverseClampedDifference = int(inverseClampedDifference) % int(availableSlidersArray.size())
	
	#For loop iteration purposes
		var absClampedDifference = abs(inverseClampedDifference)
		
		#Distributing negative difference
		if inverseClampedDifference < 0:
			
			var validSliders = []
			for j in range(availableSlidersArray.size()):
				if availableSlidersArray[j][0] > 0:
					validSliders.append(j)
			
			
			for i in range(absClampedDifference):
				if validSliders.size() == 0:
					break
					
				var targetIndex = validSliders[i % validSliders.size()]
				availableSlidersArray[targetIndex][0] -= 1
				
				if availableSlidersArray[targetIndex][0] <= 0:
					validSliders.erase(targetIndex)
					
		#Distributing positive difference
		if inverseClampedDifference > 0:
			
			var validSliders = []
			for j in range(availableSlidersArray.size()):
				if availableSlidersArray[j][0] < maxWagers:
					validSliders.append(j)
			
			for i in range(absClampedDifference):
				
				#There are no more sliders available
				if !validSliders.size():
					break
			
				var targetIndex = validSliders[i % validSliders.size()]
				availableSlidersArray[targetIndex][0] += 1
				
				if availableSlidersArray[targetIndex][0] >= maxWagers:
					validSliders.erase(targetIndex)
			
	#Applying these values
	numWagerArray[0][0] += clampedDifference
	
	#Since arrays are passed by reference, the values within the numWagerArray have already correctly been changed.
			
	
	#Updating the sliders themselves
	relevantScreen.get_node(pathSliderA).value = numWagerArray[0][0]
	relevantScreen.get_node(pathSliderB).value = numWagerArray[1][0]
	relevantScreen.get_node(pathSliderC).value = numWagerArray[2][0]
	
	_calc_averages()
	_simulate_trials()
	_calc_theoretical_trials()
	_update_display()
	
	
	
func distributeSliderB():
	#How much the slider can be moved up or down by
	var incrimentalSlideAllowance = 0
	var decrementalSlideAllowance = 0
	
	#Storing the availables seperately
	var availableSlidersArray = []
	availableSlidersArray.clear()
	
	#Creating the availableSlidersArray
	for i in range(numWagerArray.size()):
		if i != 1 && numWagerArray[i][1] == true:
			availableSlidersArray.append(numWagerArray[i])
	
	
	#The requested change by the user
	var difference = relevantScreen.get_node(pathSliderB).value - numWagerArray[1][0]
	
	#Add up the values from the other sliders to determine how much the selected slider can use
	for i in range(availableSlidersArray.size()):
		if availableSlidersArray[i][1]:
			incrimentalSlideAllowance += availableSlidersArray[i][0]
			
			
	#Add up how much the other sliders can be incrimented by
	for i in range(availableSlidersArray.size()):
		if availableSlidersArray[i][1]:
			decrementalSlideAllowance += maxWagers - availableSlidersArray[i][0]
			
	#The minimum between how much the sliders can be incrimented
	#And also how much the selected slider has to give
	decrementalSlideAllowance = min(decrementalSlideAllowance, numWagerArray[1][0])
	decrementalSlideAllowance = -decrementalSlideAllowance
	
	
	#Ensuring the slider is moved within a legal limit
	var clampedDifference = clamp(difference, decrementalSlideAllowance, incrimentalSlideAllowance)
	
	#The inverse must be applied to the OTHER sliders
	var inverseClampedDifference = -clampedDifference
	#And we can't forget about the remainder...
	
	if availableSlidersArray:
		#var remainderInverseClampedDifference = int(inverseClampedDifference) % int(availableSlidersArray.size())
	
	#For loop iteration purposes
		var absClampedDifference = abs(inverseClampedDifference)
		
		#Distributing negative difference
		if inverseClampedDifference < 0:
			
			var validSliders = []
			for j in range(availableSlidersArray.size()):
				if availableSlidersArray[j][0] > 0:
					validSliders.append(j)
			
			
			for i in range(absClampedDifference):
				if validSliders.size() == 0:
					break
					
				var targetIndex = validSliders[i % validSliders.size()]
				availableSlidersArray[targetIndex][0] -= 1
				
				if availableSlidersArray[targetIndex][0] <= 0:
					validSliders.erase(targetIndex)
					
		#Distributing positive difference
		if inverseClampedDifference > 0:
			
			var validSliders = []
			for j in range(availableSlidersArray.size()):
				if availableSlidersArray[j][0] < maxWagers:
					validSliders.append(j)
			
			for i in range(absClampedDifference):
				
				#There are no more sliders available
				if !validSliders.size():
					break
			
				var targetIndex = validSliders[i % validSliders.size()]
				availableSlidersArray[targetIndex][0] += 1
				
				if availableSlidersArray[targetIndex][0] >= maxWagers:
					validSliders.erase(targetIndex)
			
	#Applying these values
	numWagerArray[1][0] += clampedDifference
	
	#Since arrays are passed by reference, the values within the numWagerArray have already correctly been changed.
			
	
	#Updating the sliders themselves
	relevantScreen.get_node(pathSliderA).value = numWagerArray[0][0]
	relevantScreen.get_node(pathSliderB).value = numWagerArray[1][0]
	relevantScreen.get_node(pathSliderC).value = numWagerArray[2][0]
	
	_calc_averages()
	_simulate_trials()
	_calc_theoretical_trials()
	_update_display()
	
	
func distributeSliderC():
	#How much the slider can be moved up or down by
	var incrimentalSlideAllowance = 0
	var decrementalSlideAllowance = 0
	
	#Storing the availables seperately
	var availableSlidersArray = []
	availableSlidersArray.clear()
	
	#Creating the availableSlidersArray
	for i in range(numWagerArray.size()):
		if i != 2 && numWagerArray[i][1] == true:
			availableSlidersArray.append(numWagerArray[i])
	
	
	#The requested change by the user
	var difference = relevantScreen.get_node(pathSliderC).value - numWagerArray[2][0]
	
	#Add up the values from the other sliders to determine how much the selected slider can use
	for i in range(availableSlidersArray.size()):
		if availableSlidersArray[i][1]:
			incrimentalSlideAllowance += availableSlidersArray[i][0]
			
			
	#Add up how much the other sliders can be incrimented by
	for i in range(availableSlidersArray.size()):
		if availableSlidersArray[i][1]:
			decrementalSlideAllowance += maxWagers - availableSlidersArray[i][0]
			
	#The minimum between how much the sliders can be incrimented
	#And also how much the selected slider has to give
	decrementalSlideAllowance = min(decrementalSlideAllowance, numWagerArray[2][0])
	decrementalSlideAllowance = -decrementalSlideAllowance
	
	
	#Ensuring the slider is moved within a legal limit
	var clampedDifference = clamp(difference, decrementalSlideAllowance, incrimentalSlideAllowance)
	
	#The inverse must be applied to the OTHER sliders
	var inverseClampedDifference = -clampedDifference
	#And we can't forget about the remainder...
	
	if availableSlidersArray:
		#var remainderInverseClampedDifference = int(inverseClampedDifference) % int(availableSlidersArray.size())
	
	#For loop iteration purposes
		var absClampedDifference = abs(inverseClampedDifference)
		
		#Distributing negative difference
		if inverseClampedDifference < 0:
			
			var validSliders = []
			for j in range(availableSlidersArray.size()):
				if availableSlidersArray[j][0] > 0:
					validSliders.append(j)
			
			
			for i in range(absClampedDifference):
				if validSliders.size() == 0:
					break
					
				var targetIndex = validSliders[i % validSliders.size()]
				availableSlidersArray[targetIndex][0] -= 1
				
				if availableSlidersArray[targetIndex][0] <= 0:
					validSliders.erase(targetIndex)
					
		#Distributing positive difference
		if inverseClampedDifference > 0:
			
			var validSliders = []
			for j in range(availableSlidersArray.size()):
				if availableSlidersArray[j][0] < maxWagers:
					validSliders.append(j)
			
			for i in range(absClampedDifference):
				
				#There are no more sliders available
				if !validSliders.size():
					break
			
				var targetIndex = validSliders[i % validSliders.size()]
				availableSlidersArray[targetIndex][0] += 1
				
				if availableSlidersArray[targetIndex][0] >= maxWagers:
					validSliders.erase(targetIndex)
			
	#Applying these values
	numWagerArray[2][0] += clampedDifference
	
	#Since arrays are passed by reference, the values within the numWagerArray have already correctly been changed.
			
	
	#Updating the sliders themselves
	relevantScreen.get_node(pathSliderA).value = numWagerArray[0][0]
	relevantScreen.get_node(pathSliderB).value = numWagerArray[1][0]
	relevantScreen.get_node(pathSliderC).value = numWagerArray[2][0]
	
	_calc_averages()
	_simulate_trials()
	_calc_theoretical_trials()
	_update_display()
	
	
func _update_display():
	
	#Updating relevant screen (there are 10, this chooses the one being displayed)
	relevantScreen = $Control/TabContainer.get_child(selectedTab).get_child(0)
	
	relevantScreen.get_node(pathQuota).text = str(quota)
	
	
	relevantScreen.get_node(pathValueA).text = "$" + str(valueWagerA)
	relevantScreen.get_node(pathValueB).text = "$" + str(valueWagerB)
	relevantScreen.get_node(pathValueC).text = "$" + str(valueWagerC)
	
	relevantScreen.get_node(pathSliderMoneyA).text = "$" + str(valueWagerA)
	relevantScreen.get_node(pathSliderMoneyB).text = "$" + str(valueWagerB)
	relevantScreen.get_node(pathSliderMoneyC).text = "$" + str(valueWagerC)
	
	relevantScreen.get_node(pathSliderAmountA).text = str(numWagerArray[0][0]) + "x"
	relevantScreen.get_node(pathSliderAmountB).text = str(numWagerArray[1][0]) + "x"
	relevantScreen.get_node(pathSliderAmountC).text = str(numWagerArray[2][0]) + "x"
	
	relevantScreen.get_node(pathSliderA).max_value = maxWagers
	relevantScreen.get_node(pathSliderB).max_value = maxWagers
	relevantScreen.get_node(pathSliderC).max_value = maxWagers
	
	relevantScreen.get_node(pathSliderA).value = numWagerArray[0][0]
	relevantScreen.get_node(pathSliderB).value = numWagerArray[1][0]
	relevantScreen.get_node(pathSliderC).value = numWagerArray[2][0]
	
	relevantScreen.get_node(pathAverageValue).text = str(averageValue)
	relevantScreen.get_node(pathAverageQuota).text = str(averageQuota)
	
	relevantScreen.get_node(pathBinWidth).text = str(binWidth)
	relevantScreen.get_node(pathTrialsAmount).text = str(trials)
	
	relevantScreen.get_node(pathExperimentalProbability).text = str(experimentalProbability) + "%"
	
	#Probability C has additional math that fills in any inprecision because this is integer based division
	#Basically if A% + B% + C% is less than 100, the remainder will be added to C to ensure the probabiltiies
	#Always add up to 100. Don't try to decipher it, it'll make your head hurt from all the brackets.
	relevantScreen.get_node(pathChanceA).text = str((vetoWeightA * 100) / ((vetoWeightA + vetoWeightB + vetoWeightC) * 1)) + "%"
	relevantScreen.get_node(pathChanceB).text = str((vetoWeightB * 100) / ((vetoWeightA + vetoWeightB + vetoWeightC) * 1)) + "%"
	relevantScreen.get_node(pathChanceC).text = str(((vetoWeightC * 100) / ((vetoWeightA + vetoWeightB + vetoWeightC) * 1) + (100 % ((vetoWeightA * 100) / ((vetoWeightA + vetoWeightB + vetoWeightC) * 1) + (vetoWeightB * 100) / ((vetoWeightA + vetoWeightB + vetoWeightC) * 1) + (vetoWeightC * 100) / ((vetoWeightA + vetoWeightB + vetoWeightC) * 1))))) + "%"
	
