extends CanvasLayer

var animation : AnimationPlayer

@export var magic : MagicManager
@export var text0 : Label
@export var text1 : Label
@export var text2 : Label
@export var text3 : Label
@export var text4 : Label
@export var text5 : Label
@export var text6 : Label
@export var text7 : Label
@export var text8 : Label

var spellbook = {}

#lengths of menu items to calculate how many periods to use
var dot_unit = 11
var frog_unit = 150

func _ready() -> void:
	# Connect the signal 'animation_finished' to the function '_on_animation_finished'
	animation = get_node("AnimationPlayer")
	animation.connect("animation_finished", Callable(self, "_on_animation_finished"))
	animation.play("Start")
	get_spells()

# magic manager index: 0 BASIC, 1 TROPICAL, 2 SMALL, 3 FAT, 4 MUD }

func get_spells() -> void:
	#process every entry in spellbook
	for index in range(0,magic.get_spellbook_size()):
		var product = magic.output_to_index(magic.get_spell_output(index))
		var spell = magic.get_recipe_raw(index)
		if product in spellbook:
			spellbook[product].append(spell)
		else:
			spellbook[product] = [spell]
		# print(spellbook) --> { 0: [{ 1: 1 }, { 2: 1 }, { 3: 1 }, { 4: 1 }, { 0: 1 }], 1: [{ 0: 3 }], 4: [{ 1: 3 }], 2: [{ 0: 2, 1: 2 }], 3: [{ 2: 3, 4: 3 }] }
		# format: frog index: [first recipe:{needed frog type : qty}, second recipe:{1st needed frog type: qty, 2nd needed frog type : qty}]
	for spell_line in range(0,spellbook.size()):
		update_spell_line(spell_line, 0)
		
# magic manager index: 0 BASIC, 1 TROPICAL, 2 SMALL, 3 FAT, 4 MUD }
func update_spell_line(spell, spellnum): # index of spell in spellbook, index of recipe for product
	# get node path
	var spell_path = ""
	var dot_length = 630
	match spell:
		0:
			spell_path = "Control/MarginContainer/HBoxContainer/NormRecipe"
		1:
			spell_path = "Control/MarginContainer/HBoxContainer/TropRecipe"
		2:
			spell_path = "Control/MarginContainer/HBoxContainer/SmallRecipe"
		3:
			spell_path = "Control/MarginContainer/HBoxContainer/FatRecipe"
		4:
			spell_path = "Control/MarginContainer/HBoxContainer/MudRecipe"
	# iterate thru all the products in spellbook
	var current_recipe = (spellbook[spell][spellnum])
	# basic
	if 0 in current_recipe:
		get_node(spell_path + "/BasicImg").visible = true
		get_node(spell_path + "/BasicQty").visible = true
		get_node(spell_path + "/BasicQty").text = "\nx"+str(spellbook[spell][spellnum][0])
		get_node(spell_path + "/VSeparatorBasic").visible = true
		get_node(spell_path + "/VSeparatorBasic2").visible = true
		dot_length -= frog_unit
	else:
		get_node(spell_path + "/BasicImg").visible = false
		get_node(spell_path + "/BasicQty").visible = false
		get_node(spell_path + "/VSeparatorBasic").visible = false
		get_node(spell_path + "/VSeparatorBasic2").visible = false
	# trop
	if 1 in current_recipe:
		get_node(spell_path + "/TropImg").visible = true
		get_node(spell_path + "/TropQty").visible = true
		get_node(spell_path + "/TropQty").text = "\nx"+str(spellbook[spell][spellnum][1])
		get_node(spell_path + "/VSeparatorTrop").visible = true
		get_node(spell_path + "/VSeparatorTrop2").visible = true
		dot_length -= frog_unit
	else:
		get_node(spell_path + "/TropImg").visible = false
		get_node(spell_path + "/TropQty").visible = false
		get_node(spell_path + "/VSeparatorTrop").visible = false
		get_node(spell_path + "/VSeparatorTrop2").visible = false
	# small
	if 2 in current_recipe:
		get_node(spell_path + "/SmallImg").visible = true
		get_node(spell_path + "/SmallQty").visible = true
		get_node(spell_path + "/SmallQty").text = "\nx"+str(spellbook[spell][spellnum][2])
		get_node(spell_path + "/VSeparatorSmall").visible = true
		get_node(spell_path + "/VSeparatorSmall2").visible = true
		dot_length -= frog_unit
	else:
		get_node(spell_path + "/SmallImg").visible = false
		get_node(spell_path + "/SmallQty").visible = false
		get_node(spell_path + "/VSeparatorSmall").visible = false
		get_node(spell_path + "/VSeparatorSmall2").visible = false
	# fat
	if 3 in current_recipe:
		get_node(spell_path + "/LargeImg").visible = true
		get_node(spell_path + "/LargeQty").visible = true
		get_node(spell_path + "/LargeQty").text = "\nx"+str(spellbook[spell][spellnum][3])
		get_node(spell_path + "/VSeparatorLarge").visible = true
		get_node(spell_path + "/VSeparatorLarge2").visible = true
		dot_length -= frog_unit
	else:
		get_node(spell_path + "/LargeImg").visible = false
		get_node(spell_path + "/LargeQty").visible = false
		get_node(spell_path + "/VSeparatorLarge").visible = false
		get_node(spell_path + "/VSeparatorLarge2").visible = false
	# mud
	if 4 in current_recipe:
		get_node(spell_path + "/MudImg").visible = true
		get_node(spell_path + "/MudQty").visible = true
		get_node(spell_path + "/MudQty").text = "\nx"+str(spellbook[spell][spellnum][4])
		get_node(spell_path + "/VSeparatorMud").visible = true
		get_node(spell_path + "/VSeparatorMud2").visible = true
		dot_length -= frog_unit
	else:
		get_node(spell_path + "/MudImg").visible = false
		get_node(spell_path + "/MudQty").visible = false
		get_node(spell_path + "/VSeparatorMud").visible = false
		get_node(spell_path + "/VSeparatorMud2").visible = false
	# assign dots
	var dot_text = "\n"
	while dot_length >= 0:
		dot_text += ". "
		dot_length -= dot_unit
	get_node(spell_path + "/DotSpacers").text = dot_text
		

func _on_open_button_pressed() -> void:
	#update_spells()
	#if get_tree().root.get_child(0) is Main:
		#get_tree().root.get_child(0).play_shop_music(true)
	animation.play("Transition_In")
	$OpenButton.visible = false
	$Control.visible = true
	#get_tree().paused = true


func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "Transition_Out":
		# Unpause the game after the "Transition_Out" animation finishes
		get_tree().paused = false
		#if get_tree().root.get_child(0) is Main:
			#get_tree().root.get_child(0).play_shop_music(false)


func _on_close_button_pressed() -> void:
	animation.play("Transition_Out")
	$OpenButton.visible = true
