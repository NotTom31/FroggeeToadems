extends CanvasLayer

var animation : AnimationPlayer

@export var magic : MagicManager

# all spells, as outlined in magic manager, at init. currently does not update mid-game
var spellbook = {}
var frog_index = ["Basic","Trop","Small","Fat","Mud","Bright","Dart","Orange","Purple"]
# index for which spell is currently displayed if there are more than one recipe
var spelldisplayindex = {}

var spellbook_open = false

#lengths of menu items to calculate how many periods to use
var dot_unit = 11
var frog_unit = 150
var update_time = 2


func _ready() -> void:
	# Connect the signal 'animation_finished' to the function '_on_animation_finished'
	animation = get_node("AnimationPlayer")
	animation.connect("animation_finished", Callable(self, "_on_animation_finished"))
	animation.play("Start")
	get_spells()

# magic manager index: 0 BASIC, 1 TROPICAL, 2 SMALL, 3 FAT, 4 MUD, 5 BRIGHT }

func get_spells() -> void:
	#process every entry in spellbook
	for index in range(0,magic.get_spellbook_size()):
		var product = magic.output_to_index(magic.get_spell_output(index))
		var spell = magic.get_recipe_raw(index)
		if product in spellbook:
			# add additional spell option
			spellbook[product].append(spell)
		else:
			spellbook[product] = [spell]
			spelldisplayindex[product] = 0
		# print(spellbook) --> { 0: [{ 1: 1 }, { 2: 1 }, { 3: 1 }, { 4: 1 }, { 0: 1 }], 1: [{ 0: 3 }], 4: [{ 1: 3 }], 2: [{ 0: 2, 1: 2 }], 3: [{ 2: 3, 4: 3 }] }
		# format: frog index: [first recipe:{needed frog type : qty}, second recipe:{1st needed frog type: qty, 2nd needed frog type : qty}]
	for spell_line in range(0,spellbook.size()):
		update_spell_line(spell_line, 0)
		
# magic manager index: 0 BASIC, 1 TROPICAL, 2 SMALL, 3 FAT, 4 MUD, 5 BRIGHT, 6 DART, 7 ORANGE, 8 PURPLE }

# update row of spells. takes product (spell; index of spell 0-n) and spell number (if product has multiple spells)
func update_spell_line(spell, spellnum): # index of spell in spellbook, index of recipe for product
	# get node path
	var spell_path = ""
	var dot_length = 630
	var prefix = ""
	
	# get path of row for this frogs recipe
	spell_path = "Control/MarginContainer/HBoxContainer/"+str(frog_index[spell])+"Recipe"
	
	# quantity prefix assign
	if spell == 0:
		# note: bandaid fix for basic frog, will not work for other "any" recipes if we added in future
		prefix = "\n(any) x"
		dot_length -= 55
	else:
		#standard prefix
		prefix = "\nx"
	
	# iterate thru all the products in spellbook
	var current_recipe = (spellbook[spell][spellnum])
	# basic
	for ing in frog_index:
		if frog_index.find(ing) in current_recipe:
			get_node(spell_path + "/"+ing+"Img").visible = true
			get_node(spell_path + "/"+ing+"Qty").visible = true
			# vile code to take the quantity of ing frog type needed for spellnum index of spell listed to make spell product frog from spellbook
			get_node(spell_path + "/"+ing+"Qty").text = prefix+str(spellbook[spell][spellnum][frog_index.find(ing)])
			get_node(spell_path + "/VSeparator"+ing).visible = true
			dot_length -= frog_unit
		else:
			get_node(spell_path + "/"+ing+"Img").visible = false
			get_node(spell_path + "/"+ing+"Qty").visible = false
			get_node(spell_path + "/VSeparator"+ing).visible = false
	
	# assign dots
	var dot_text = "\n"
	while dot_length >= 0:
		dot_text += ". "
		dot_length -= dot_unit
	get_node(spell_path + "/DotSpacers").text = dot_text
	# move spell index
	spelldisplayindex[spell] += 1
	if spelldisplayindex[spell] >= spellbook[spell].size():
		spelldisplayindex[spell] = 0
		

func _on_open_button_pressed() -> void:
	#update_spells()
	#if get_tree().root.get_child(0) is Main:
		#get_tree().root.get_child(0).play_shop_music(true)
	animation.play("Transition_In")
	$OpenButton.visible = false
	$Control.visible = true
	#get_tree().paused = true
	spellbook_open = true
	# loop through spells until close
	while spellbook_open == true:
		await get_tree().create_timer(update_time).timeout
		for spell_line in range(0,spellbook.size()):
			# only update spells w multiple recipes
			if spellbook[spell_line].size() > 1:
				update_spell_line(spell_line, spelldisplayindex[spell_line])
	


func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "Transition_Out":
		# Unpause the game after the "Transition_Out" animation finishes
		get_tree().paused = false
		#if get_tree().root.get_child(0) is Main:
			#get_tree().root.get_child(0).play_shop_music(false)


func _on_close_button_pressed() -> void:
	animation.play("Transition_Out")
	$OpenButton.visible = true
	# end spellbook recipe loop
	spellbook_open = false
