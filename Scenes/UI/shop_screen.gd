class_name ShopScreen
extends Node

var customers_text = [
	{
		"name": "Plague cat: ", 
		"dialogues": ["Yeeack cheche rrowr. Ah hem! Pardon me; Scratch fever still spreads, a great many claws are stuck sunken into tree casings.  ", "For my cure I will need _ and _. Please help", "lest Alpha Meatball notch my ears for my failure."],
		"requested_frogs": []
	},
	{
		"name": "Mask cat: ", 
		"dialogues": ["I require frogs. _, _, _.", "Their purpose? My jutsu needs a conduit from which to channel by.", "All other techniques are worthless before my eyes."],
		"requested_frogs": []
	},
	{
		"name": "Scar cat: ", 
		"dialogues": ["Ah ha, yes, yes. I am in dire need of aid, what say you? ", "Yes, yes, I can see many of your wares. How much is it worth?", "Fine, keep your secrets. Shut up and get me _, _, _."],
		"requested_frogs": []
	},
	{
		"name": "Chuddly: ", 
		"dialogues": ["Salutations my brother in Meist.", "I need your most potent frogs. Based on my opponents aura I sussed out I will cop all the bussin ones. _, _, _.", "Thank you for kino maxing. I don’t pay the tax."],
		"requested_frogs": []
	},
	{
		"name": "Minnum Cat: ", 
		"dialogues": ["Maow, meouu, meqw, nneow.", "*with a seemingly feline paw it motions*", "_, _, _"],
		"requested_frogs": []
	},
	{
		"name": "Void spawns: ", 
		"dialogues": ["We have need of the preciouses. As our power grows so does our appetite.", "Your clipped whiskers could never fathom. We will possess the Eternal Long Stretch.", "We have foreseen. _, _, _ will guide us."],
		"requested_frogs": []
	},
	{
		"name": "Gorf: ", 
		"dialogues": ["Hellow my fellow -croooa- Cat.", "I will purchase _, _, _, _, _, _, _, _, _. We have a family vacation planned- ughh I mean, a family feast!", "That I -ribb- I will host. *cough* *cough* sid ssey buy ist??"],
		"requested_frogs": []
	},
	{
		"name": "Eye: ", 
		"dialogues": ["Gaze long into my depthless eye. Hear what it yearns for.", "The echoing answer. Frogs.", "_, _, _. I do as the void commands."],
		"requested_frogs": []
	},
	{
		"name": "Tac: ", 
		"dialogues": ["how to play game", "stack frogs", "win"],
		"requested_frogs": []
	}
]


@onready var shopkeep = $Shopkeep

@onready var customer_sprites = [
	$PlagueCat,
	$Maskcat,
	$Purrzerk,
	$ChadCat,
	$WeirdGuy,
	$Void,
	$Gorf,
	$Eyecat
]

var current_customer_id = -1
var current_dialogue_index = 0
var current_word_index = 0
var is_displaying = false
var dialogue_speed = 0.05 # seconds between words
var tac_talking = false

@onready var name_label = $Panel/MarginContainer2/VBoxContainer/Name
@onready var dialogue_label = $Panel/MarginContainer2/VBoxContainer/Text
@onready var next_button = $Panel/MarginContainer2/VBoxContainer/HBoxContainer/NextButton
@onready var restart_button = $Panel/MarginContainer2/VBoxContainer/HBoxContainer/ResetButton

# Function to set requested frogs for the current customer
func set_requested_frogs(customer_id: int, frogs: Array):
	if customer_id >= 0 and customer_id < customers_text.size():
		customers_text[customer_id]["requested_frogs"] = frogs
	else:
		print("Invalid customer ID:", customer_id)

# Function to start a dialogue for a given customer
func start_dialogue(customer_id: int):
	update_customer_by_id(customer_id)

# Restart the dialogue for the current customer
func restart_dialogue():
	if current_customer_id >= 0:
		current_dialogue_index = 0
		current_word_index = 0
		dialogue_label.text = ""  
		display_next_dialogue()

# Update the dialogue and frog requests based on customer ID
func update_customer_by_id(customer_id: int):
	if customer_id >= 0 and customer_id < customers_text.size():
		current_customer_id = customer_id
		current_dialogue_index = 0 
		current_word_index = 0 
		is_displaying = false

		var customer_data = customers_text[customer_id]
		name_label.text = customer_data["name"]
		dialogue_label.text = ""  # Clear dialogue initially
		
		# Set the active customer sprite
		for i in range(customer_sprites.size()):
			customer_sprites[i].visible = (i == customer_id)
		
		display_next_dialogue()
	else:
		print("Invalid customer ID:", customer_id)

# Display the next dialogue and replace underscores with frogs
func display_next_dialogue():
	if current_customer_id >= 0:
		var customer_data = customers_text[current_customer_id]
		if current_dialogue_index < customer_data["dialogues"].size():
			var current_dialogue = customer_data["dialogues"][current_dialogue_index]
			# Replace underscores with requested frogs
			var modified_dialogue = replace_underscores_with_frogs(current_dialogue, current_customer_id)
			var words = modified_dialogue.split(" ")
			if current_word_index < words.size():
				if !is_displaying:
					is_displaying = true
					next_button.disabled = true  # Disable the next button
					display_word(words)
			else:
				current_dialogue_index += 1
				current_word_index = 0 
				dialogue_label.text = "" 
				display_next_dialogue()
		else:
			tac_talking = false
			print("No more dialogues for this customer")
			next_button.disabled = false 

# Function to display words one by one
func display_word(words: Array):
	if current_word_index < words.size():
		dialogue_label.text += words[current_word_index] + " "
		current_word_index += 1
		tac_talk(true)
		await get_tree().create_timer(dialogue_speed).timeout  
		tac_talk(false)
		display_word(words)  
	else:
		is_displaying = false 
		next_button.disabled = false

# Replace underscores in the dialogue with specific frogs requested by the customer
func replace_underscores_with_frogs(dialogue: String, customer_id: int) -> String:
	var modified_dialogue = dialogue
	var customer_data = customers_text[customer_id]
	var frog_count = customer_data.get("requested_frogs", []).size()
	var requested_frogs = customer_data.get("requested_frogs", [])
	
	var frog_index = 0
	# Replace the underscores with the requested frogs
	while modified_dialogue.find("_") != -1 and frog_index < frog_count:
		modified_dialogue = replace_first_underscore_with_frog(modified_dialogue, requested_frogs[frog_index])
		frog_index += 1

	# If there are still underscores but no more requested frogs, use "Frog" as a fallback
	while modified_dialogue.find("_") != -1:
		modified_dialogue = replace_first_underscore_with_frog(modified_dialogue, "Frog")
	
	return modified_dialogue

# Helper function to replace only the first occurrence of an underscore with a frog name
func replace_first_underscore_with_frog(dialogue: String, frog_name: String) -> String:
	var underscore_index = dialogue.find("_")
	if underscore_index != -1:
		return dialogue.substr(0, underscore_index) + frog_name + dialogue.substr(underscore_index + 1)
	return dialogue

# Button pressed functions to update customer
func _on_NextButton_pressed():
	if !is_displaying: 
		display_next_dialogue()

func _on_RestartButton_pressed():
	restart_dialogue()

# Connect buttons on ready
func _ready():
	next_button.connect("pressed", Callable(self, "_on_NextButton_pressed"))
	restart_button.connect("pressed", Callable(self, "_on_RestartButton_pressed"))

func _on_one_pressed() -> void:
	update_customer_by_id(0)

func _on_two_pressed() -> void:
	update_customer_by_id(1)

func _on_three_pressed() -> void:
	update_customer_by_id(2)

func _on_four_pressed() -> void:
	update_customer_by_id(3)

func _on_five_pressed() -> void:
	update_customer_by_id(4)

func _on_six_pressed() -> void:
	update_customer_by_id(5)

func _on_seven_pressed() -> void:
	update_customer_by_id(6)

func _on_eight_pressed() -> void:
	update_customer_by_id(7)

func tac_dialogue() -> void:
	update_customer_by_id(8)
	tac_talking = true
	
func tac_talk(is_talk : bool):
	pass
	#if get_tree().root.get_child(0) is Main:
		#get_tree().root.get_child(0).shopkeep_talk(is_talk)
