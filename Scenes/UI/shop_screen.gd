extends Node

var customers_text = [
	{"name": "Plague cat: ", "dialogues": ["Yeeack cheche rrowr. Ah hem! Pardon me; Scratch fever still spreads, a great many claws are stuck sunken into tree casings.  ", " For my cure I will need ____ and ____. Please help", "lest Alpha Meatball notch my ears for my failure"]},
	{"name": "Mask cat: ", "dialogues": ["Hi there!", "Can you help me?", "I need something special."]},
	{"name": "Scar cat: ", "dialogues": ["Greetings!", "I need some frogs.", "Hurry up!"]},
	{"name": "Chuddly: ", "dialogues": ["What's up?", "One potion, please!", "Make it quick."]},
	{"name": "Minnum Cat: ", "dialogues": ["Hello!", "Do you have potions?", "I'll take that one."]},
	{"name": "Void spawns: ", "dialogues": ["Hey!", "I need something strong.", "Yummers"]},
	{"name": "Gorf: ", "dialogues": ["Hi!", "Just browsing today.", "give potion"]},
	{"name": "Eye: ", "dialogues": ["Hi!", "Just browsing today.", "Give potion"]}
]

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
var dialogue_speed = 0.05 #seconds between words

@onready var name_label = $Panel/MarginContainer2/VBoxContainer/Name
@onready var dialogue_label = $Panel/MarginContainer2/VBoxContainer/Text
@onready var next_button = $Panel/MarginContainer2/VBoxContainer/NextButton 
@onready var restart_button = $Panel/MarginContainer2/VBoxContainer/NextButton2 


func start_dialogue(customer_id: int):
	update_customer_by_id(customer_id)


func restart_dialogue():
	if current_customer_id >= 0:
		current_dialogue_index = 0
		current_word_index = 0
		dialogue_label.text = ""  
		display_next_dialogue() 


func update_customer_by_id(customer_id: int):
	if customer_id >= 0 and customer_id < customers_text.size():
		current_customer_id = customer_id
		current_dialogue_index = 0 
		current_word_index = 0 
		is_displaying = false

		var customer_data = customers_text[customer_id]
		name_label.text = customer_data["name"]
		dialogue_label.text = ""  # Clear dialogue initially
		
		for i in range(customer_sprites.size()):
			customer_sprites[i].visible = (i == customer_id)
		
		display_next_dialogue()
	else:
		print("Invalid customer ID:", customer_id)


func display_next_dialogue():
	if current_customer_id >= 0:
		var customer_data = customers_text[current_customer_id]
		if current_dialogue_index < customer_data["dialogues"].size():
			var current_dialogue = customer_data["dialogues"][current_dialogue_index]
			var words = current_dialogue.split(" ")
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
			print("No more dialogues for this customer")
			next_button.disabled = false 

func display_word(words: Array):
	if current_word_index < words.size():
		dialogue_label.text += words[current_word_index] + " "
		current_word_index += 1
		await get_tree().create_timer(dialogue_speed).timeout  
		display_word(words)  
	else:
		is_displaying = false 
		next_button.disabled = false

func _on_NextButton_pressed():
	if !is_displaying: 
		display_next_dialogue()

func _on_RestartButton_pressed():
	restart_dialogue()

func _ready():
	next_button.connect("pressed", Callable(self, "_on_NextButton_pressed"))
	restart_button.connect("pressed", Callable(self, "_on_RestartButton_pressed"))








func _on_one_pressed() -> void:
	update_customer_by_id(0)

func _on_four_pressed() -> void:
	update_customer_by_id(3)
	
func _on_seven_pressed() -> void:
	update_customer_by_id(6)
func _on_two_pressed() -> void:
	update_customer_by_id(1)
	
func _on_five_pressed() -> void:
	update_customer_by_id(4)
	
func _on_eight_pressed() -> void:
	update_customer_by_id(7)

func _on_three_pressed() -> void:
	update_customer_by_id(2)
	
func _on_six_pressed() -> void:
	update_customer_by_id(5)
