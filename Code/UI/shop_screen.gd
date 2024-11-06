class_name ShopScreen
extends Node

var customers_text = [
	{
		"name": "Purrzerk: ",
		"dialogues": ["Ah ha, yes, yes. I am in dire need of aid; what say you?", 
		"Yes, yes, I can see many of your wares. How much is it worth?", 
		"Fine, keep your secrets. Shut up and get me _."],
		"requested_frogs": []
	},
	{
		"name": "Mask cat: ", 
		"dialogues": ["I require frogs.", 
		"_. Their purpose? My jutsu needs a conduit from which to channel by.", 
		"All other techniques are worthless before my eyes."],
		"requested_frogs": []
	},
	{
		"name": "Chuddly: ", 
		"dialogues": ["Salutations, my brother in Meist.", 
		"I need your most potent frogs. Based on my opponent's aura that I sussed out, I will cop all the bussin ones. _.", 
		"Thank you for kino maxing. I don’t pay the tax."],
		"requested_frogs": []
	},
	{
		"name": "Gorf: ", 
		"dialogues": ["Hellow my fellow -croooa- Cat.", 
		"I will purchase _. We have a family vacation planned- ughh I mean, a family feast!", 
		"That I -ribb- I will host. *cough* *cough* sid ssey buy ist??"],
		"requested_frogs": []
	},
	{
		"name": "Plague cat: ", 
		"dialogues": ["Yeeack cheche rrowr. Ah hem! Pardon me; scratch fever still spreads; a great many claws are stuck sunken into tree casings.", 
		"For my cure I will need _.", 
		"lest Alpha Meatball notch my ears for my failure."],
		"requested_frogs": []
	},
	{
		"name": "Void spawns: ", 
		"dialogues": ["We have need of the preciouses. As our power grows, so does our appetite.", 
		"Your clipped whiskers could never fathom. We will possess the Eternal Long Stretch.", 
		"We have foreseen. _ will guide us."],
		"requested_frogs": []
	},
	{
		"name": "Minnum Cat: ", 
		"dialogues": ["Maow, meouu, meqw, nneow.", 
		"*with a seemingly feline paw it motions*", 
		"_."],
		"requested_frogs": []
	},
	{
		"name": "?: ", 
		"dialogues": ["Gaze long into my depthless eye. Hear what it yearns for.", 
		"The echoing answer. Frogs.", 
		"_. Do as the void commands."],
		"requested_frogs": []
	},
	{
		"name": "Tac: ", 
		"dialogues": ["In this game you stack frogs to cast spells", 
		"Weird I know, you'll be given a spell book and a wand, once you've stacked the required frogs in any order go ahead and pick up the wand", 
		"Click on the stack with your wand to cast your frog magic and summon another frog. We've got customers to satisfy", "Here comes our first customer of the day!"],
		"requested_frogs": []
	}
]


#@onready var shopkeep = $Shopkeep

@onready var customer_sprites = [
	$Purrzerk,
	$Maskcat,
	$ChadCat,
	$Gorf,
	$PlagueCat,
	$Void,
	$WeirdGuy,
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
@onready var next_button = $Panel/MarginContainer2/VBoxContainer/VBoxContainer/HBoxContainer/NextButton
@onready var restart_button = $Panel/MarginContainer2/VBoxContainer/VBoxContainer/HBoxContainer/ResetButton

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
			if tac_talking:
				tac_talking = false
				update_customer_by_id(0)
			print("No more dialogues for this customer")
			next_button.disabled = false 

# Function to display words one by one
func display_word(words: Array):
	if get_tree().root.get_child(0) is Main && tac_talking:
		get_tree().root.get_child(0).shopkeep_talk(true)
	if current_word_index < words.size():
		dialogue_label.text += words[current_word_index] + " "
		current_word_index += 1
		if get_tree().root.get_child(0) is Main && current_word_index % 3 == 0: #play beep text every 3 words
			get_tree().root.get_child(0).play_sound("beep_text")
		await get_tree().create_timer(dialogue_speed).timeout  
		display_word(words)  
	else:
		is_displaying = false 
		next_button.disabled = false
		if get_tree().root.get_child(0) is Main && tac_talking:
			get_tree().root.get_child(0).shopkeep_talk(false)

# Replace underscores in the dialogue with specific frogs requested by the customer
func replace_underscores_with_frogs(dialogue: String, customer_id: int) -> String:
	var modified_dialogue = dialogue
	var customer_data = customers_text[customer_id]
	var requested_frogs = customer_data.get("requested_frogs", [])
	
	# Find the first underscore
	var underscore_index = modified_dialogue.find("_")
	if underscore_index != -1:
		# Manually join all frog names with ", "
		var frogs_list = ""
		for i in range(requested_frogs.size()):
			frogs_list += requested_frogs[i]
			if i < requested_frogs.size() - 1:
				frogs_list += ", "  # Add ", " between frog names
		
		# Replace the single underscore with the full list of requested frogs
		modified_dialogue = modified_dialogue.substr(0, underscore_index) + frogs_list + modified_dialogue.substr(underscore_index + 1)
	
	return modified_dialogue



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
	self.visible = true

func tac_dialogue() -> void:
	update_customer_by_id(8)
	tac_talking = true
	
#func tac_talk(is_talk : bool):
	#if get_tree().root.get_child(0) is Main:
		#get_tree().root.get_child(0).shopkeep_talk(is_talk)

var level_num = 0

func _on_submit_order_button_pressed() -> void:
	var is_win : bool
	if get_tree().root.get_child(0) is Main:
		is_win = get_tree().root.get_child(0).get_node("LevelManager").check_for_win()
	if is_win:
		self.visible = false
