class_name ShopScreen
extends Node

var customers_text = [
	{
		"name": "Purrzerk: ",
		"dialogues": ["Ah ha, yes, yes. I am in dire need of aid; what say you?", 
		"Yes, yes, I can see many of your wares. How much is it worth?", 
		"Fine, keep your secrets. Shut up and get me _."],
		"requested_frogs": [],
		"extra_dialogue": ["Hurry, knave. The sweet wind calls.", "What say you? Quiet, now.","Ah ha, yes, very good."]
	},
	{
		"name": "Miyawukage: ", 
		"dialogues": ["I require frogs.", 
		"_. Their purpose? My jutsu needs a conduit from which to channel by.", 
		"All other techniques are worthless before my eyes."],
		"requested_frogs": [],
		"extra_dialogue": ["My exhausted chakras need salve.", "Can you meet this trial?", "Believe it !"]# note: separated the ! because beep sound only plays on third word
	},
	{
		"name": "Chuddly: ", 
		"dialogues": ["Salutations, my brother in Meist.", 
		"I need your most potent frogs. Based on my opponent's aura that I sussed out, I will cop all the bussin ones. _.", 
		"I don’t pay the tax."],
		"requested_frogs": [],
		"extra_dialogue": ["Only the most mogging frogs for this glizzy rizzler.","Thank you for kino maxing."]
	},
	{
		"name": "Gorf: ", 
		"dialogues": ["Hellow my fellow -croooa- Cat.", 
		"I will purchase _. We have a family vacation planned- ughh I mean, a family feast!", 
		"That I -ribb- I will host. *cough* *cough* sid ssey buy ist??"],
		"requested_frogs": [],
		"extra_dialogue": ["I do, I do, hate, -croooa- water.","*is not looking at that fly*", ]
	},
	{
		"name": "Pestarzt: ", 
		"dialogues": ["Yeeack cheche rrowr. Ah hem! Pardon me; scratch fever still spreads; a great many claws are stuck sunken into tree casings.", 
		"For my cure I will need _.", 
		"lest Alpha Meatball notch my ears for my failure."],
		"requested_frogs": [],
		"extra_dialogue": ["Cheack ick meuugh.", "Yeeeauck. Beg your pardon.", "*raspy breathing*"]
	},
	{
		"name": "Void Spawns: ", 
		"dialogues": ["Gaze long into my depthless eye. Hear what it yearns for.", 
		"The echoing answer. Frogs.", 
		"_. Do as the void commands."],
		"requested_frogs": [],
		"extra_dialogue": ["The tethers will hold.","The flat eternity is still wanting. Frogs.", "You understand now."]
	},
	{
		"name": "Minnum Cat: ", 
		"dialogues": ["Maow, meouu, meqw, nneow...", 
		"*with a seemingly feline paw it motions*", 
		"_."],
		"requested_frogs": [],
		"extra_dialogue": ["Meouu, nneow ...", "Moau, smeow ...", "Moaw, meuou ..." ]# note: separated the ... because beep sound only plays on third word
	},
	{
		"name": "???: ", 
		"dialogues": ["We have need of the preciouses. As our power grows, so does our appetite.", 
		"Your clipped whiskers could never fathom. We will possess the Eternal Long Stretch.", 
		"We have foreseen. _ will guide us."],
		"requested_frogs": [],
		"extra_dialogue": ["Outstretched is our paw.", "Our power quakes in need.", "Make haste, rodent!", ]
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
var extra_dialogue_index = 0
var current_order = [0,0,0,0,0,0,0,0,0]

@onready var name_label = $TextureRect/MarginContainer2/VBoxContainer/Name
@onready var dialogue_label = $TextureRect/MarginContainer2/VBoxContainer/Text
@onready var next_button = $TextureRect/MarginContainer2/VBoxContainer/VBoxContainer/HBoxContainer/NextButton
@onready var restart_button = $TextureRect/MarginContainer2/VBoxContainer/VBoxContainer/HBoxContainer/ResetButton

# for updating frog display
var frog_path = "TextureRect/MarginContainer2/VBoxContainer/FrogOrders/"
var frog_names = ["Basic", "Trop", "Mud", "Small", "Fat", "Bright", "Dart", "Orange", "Purple"]
var frog_names_parse = ["Basic Frog", "Tropical Frog", "Mud Frog", "Small Frog", "Large Frog", "Bright Frog", "Dart Frog", "Orange Frog", "Purple Frog"]
var order_display_complete = false
var frog_display_width = 150

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
		extra_dialogue_index = 0
		dialogue_label.text = ""  
		display_next_dialogue()

# Update the dialogue and frog requests based on customer ID
func update_customer_by_id(customer_id: int):
	if customer_id >= 0 and customer_id < customers_text.size():
		current_customer_id = customer_id
		current_dialogue_index = 0 
		current_word_index = 0 
		extra_dialogue_index = 0
		clear_order_display()
		current_order = [0,0,0,0,0,0,0,0,0]
		order_display_complete = false
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
				current_dialogue = ""
				current_word_index = 0 
				dialogue_label.text = "" 
				display_next_dialogue()
		# dialogue is over
		else:
		# if tac, move to first customer
			#print("No more dialogues for this customer")
			if tac_talking:
				tac_talking = false
				update_customer_by_id(0)
		# if not tac, play loop of extra dialogue
			else:
				if extra_dialogue_index < customer_data["extra_dialogue"].size():
					# choose new dialogue from array of extra dialogue options
					var current_dialogue = customer_data["extra_dialogue"][extra_dialogue_index]
					# Replace underscores with requested frogs
					var modified_dialogue = replace_underscores_with_frogs(current_dialogue, current_customer_id)
					var words = modified_dialogue.split(" ")
					if current_word_index < words.size():
						if !is_displaying:
							is_displaying = true
							next_button.disabled = true  # Disable the next button
							display_word(words)
					else:
						extra_dialogue_index += 1
						current_word_index = 0 
						dialogue_label.text = "" 
						current_dialogue = ""
						display_next_dialogue()
				else:
					extra_dialogue_index = 0
					display_next_dialogue()

# Function to display words one by one
func display_word(words: Array):
	if get_tree().root.get_child(0) is Main && tac_talking:
		get_tree().root.get_child(0).shopkeep_talk(true)
	if current_word_index < words.size():
		dialogue_label.text += words[current_word_index] + " "
		current_word_index += 1
		if get_tree().root.get_child(0) is Main && current_word_index % 3 == 0: #play beep text every 3 words
			get_tree().root.get_child(0).play_sound("beep_text"+str(current_customer_id))
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
			if order_display_complete == false:
				update_order_display(requested_frogs[i])
			if i < requested_frogs.size() - 1:
				frogs_list += ", "  # Add ", " between frog names
		order_display_complete = true
		# Replace the single underscore with the full list of requested frogs
		modified_dialogue = modified_dialogue.substr(0, underscore_index) + frogs_list + modified_dialogue.substr(underscore_index + 1)
	return modified_dialogue
	## If there are still underscores but no more requested frogs, use "Frog" as a fallback
	#while modified_dialogue.find("_") != -1:
		#modified_dialogue = replace_first_underscore_with_frog(modified_dialogue, "Frog")
	#
	#return modified_dialogue

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

# FROG ORDER VISUAL DISPLAY

# magic manager index: 0 BASIC, 1 TROPICAL, 2 SMALL, 3 FAT, 4 MUD, 5 BRIGHT }
func frog_string_to_id(frog):
	var frog_id = frog_names_parse.find(frog)
	return(frog_id)

func clear_order_display():
	$TextureRect/Panel2.visible = false
	$TextureRect/Panel2.size.x = 30
	$TextureRect/Panel2.position.x = 517
	for frog in frog_names:
		get_node(frog_path + frog).visible = false
		get_node(frog_path + "VSeparator" + frog).visible = false

func update_order_display(frogstring):
	$TextureRect/Panel2.visible = true
	var frog = frog_names[frog_string_to_id(frogstring)]
	#update background size size
	if current_order[frog_string_to_id(frogstring)] == 0:
		$TextureRect/Panel2.size.x += frog_display_width
		$TextureRect/Panel2.position.x -= frog_display_width/2
	# make visible
	get_node(frog_path + frog).visible = true
	get_node(frog_path + "VSeparator" + frog).visible = true
	# update qty
	current_order[frog_string_to_id(frogstring)] += 1
	get_node(frog_path + frog + "/HBoxContainer/" + frog + "Qty").text = "\nx" + str(current_order[frog_string_to_id(frogstring)])

func _on_submit_order_button_pressed() -> void:
	var is_win : bool
	if get_tree().root.get_child(0) is Main:
		is_win = get_tree().root.get_child(0).get_node("LevelManager").check_for_win()
	if is_win:
		self.visible = false
