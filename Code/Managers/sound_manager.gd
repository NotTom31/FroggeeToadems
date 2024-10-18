class_name SoundManager
extends Node2D

# brendan's beautiful perfect code

# TABLE OF CONTENTS:
# 1) AUDIO CONFIGS (~28)
	# audio paths and customizations for db, pitch, etc set
# 2) VARIABLES/UTILS: (~80)
	# buses are initialized
	# randomizer and round robin variable
# 3) AMBIANCE: (~117)
# 4) MUSIC: (~130)
	# play music on level start
	# dynamic music layer system
	# toggle shop / main
# 5) SFX: (~184)
	# take calls from elsewhere in code
	# check audio configs
	# round-robin style player
# 6) BUS MANAGEMENT: (~304)
	# logic used for volume sliders in settings menu 



# 1) AUDIO CONFIGS
# this portion of code is where volume, volume variety, and pitch variety are set for each effect
# additionally, the configs audio file path(s) are specified
# key can be found below array
# NOTE! filepaths ["null] indicate a planned sound effect not yet implemented
# the debugger will return a message confirming implementation if and only if the filepath says ["null"]
var sound_config = {
	# UI
	"menu_click": [-6, -2, 1, 0.85, 1.2, ["res://Assets/Audio/SFX/Newstufftoadd/click1_-6dB.wav", "res://Assets/Audio/SFX/Newstufftoadd/click2_-6dB.wav"]],
	"menu_hover": [-18, -3, 1, 0.8, 1.3, ["res://Assets/Audio/SFX/Newstufftoadd/hoverclick1_-7dB.wav", "res://Assets/Audio/SFX/Newstufftoadd/hoverclick2_-7dB.wav"]],
	# planned ui:
	"open_spellbook": [0, -4, 2, 0.85, 1.2, ["null"]],
	"close_spellbook": [0, -4, 2, 0.85, 1.2, ["null"]],
	"open_shop": [0, -4, 2, 0.85, 1.2, ["null"]],
	"close_shop": [0, -4, 2, 0.85, 1.2, ["null"]],
	# FROG SFX
	"boing1": [-2, -4, 2, 0.7, 1.3, ["res://Assets/Audio/SFX/boing_1_-7dB.wav","res://Assets/Audio/SFX/boing_2_-7dB.wav","res://Assets/Audio/SFX/boing_3_-7dB.wav","res://Assets/Audio/SFX/boing_4_-7dB.wav"]],
	"bounce_charge": [-7, -4, 2, 0.85, 1.2, ["res://Assets/Audio/SFX/bounce_charge1_-7dB.wav", "res://Assets/Audio/SFX/bounce_charge2_-7dB.wav"]],
	# unimplemented sound "frog_click" for when clicking on frogs
	"frog_click": [0, -4, 2, 0.85, 1.2, ["res://Assets/Audio/SFX/frogimpact1.wav","res://Assets/Audio/SFX/frogimpact2.wav"]],
	# planned sound "frog_spawn" for when a new frog appears
	"frog_spawn": [0, -4, 2, 0.85, 1.2, ["null"]],
	"frog_snap": [-1, -4, 2, 0.85, 1.2, ["res://Assets/Audio/SFX/frogsnap_-7dB.wav"]],
	"tiny_ribbit" : [-10, -4, 2, 0.85, 1.2, ["res://Assets/Audio/SFX/ribbit_tiny1_-9dB.wav","res://Assets/Audio/SFX/ribbit_tiny2_-9dB.wav","res://Assets/Audio/SFX/ribbit_tiny3_-9dB.wav"]],
	"default_ribbit": [-5, -4, 2, 0.85, 1.2, ["res://Assets/Audio/SFX/ribbit_normal1_-8dB.wav","res://Assets/Audio/SFX/ribbit_normal2_-8dB.wav"]],
	"big_ribbit": [-3, -4, 2, 0.85, 1.2, ["res://Assets/Audio/SFX/ribbitBIG_-8dB.wav"]],
	# MAGIC SFX
	"magic" : [4, -4, 2, 0.85, 1.2, ["res://Assets/Audio/SFX/post-jam addition/magic1.wav", "res://Assets/Audio/SFX/post-jam addition/magic2.wav", "res://Assets/Audio/SFX/post-jam addition/magic3.wav"]],
	"magic_equip" : [2.5, -4, 2, 0.85, 1.2, ["res://Assets/Audio/SFX/post-jam addition/magicequip.wav", "res://Assets/Audio/SFX/post-jam addition/magicequip2.wav"]],
	"magic_unequip" : [3, -4, 2, 0.85, 1.2, ["res://Assets/Audio/SFX/post-jam addition/magicunequip.wav", "res://Assets/Audio/SFX/post-jam addition/magicunequip2.wav"]],
	"magic_fail" : [4, -4, 2, 0.85, 1.2, ["res://Assets/Audio/SFX/post-jam addition/magicfail1.wav", "res://Assets/Audio/SFX/post-jam addition/magicfail2.wav"]],
	# NPCS
	"beep_text": [-3, -4, 5, 0.7, 1.3, ["res://Assets/Audio/SFX/GWJ73_SFX_beepText_loop_-7dB.wav"]],
	# unimplemented mock-up sound "beep_text_gorf" specifically for gorf's ribbit-meows
	"beep-text_gorf": [-3, -4, 5, 0.7, 1.3, ["res://Assets/Audio/SFX/gorf_meow_mockup1.wav", "res://Assets/Audio/SFX/gorf_meow_mockup2.wav", "res://Assets/Audio/SFX/gorf_meow_mockup3.wav"]],
	#one day maybe every customer will sound different....
	#OTHER
	"splash_med": [-6, -5, 1, 0.6, 1.5, ["res://Assets/Audio/SFX/splash_medium_-6dB.wav"]],
	"lillypad_impact": [0, -4, 2, 0.85, 1.2, ["res://Assets/Audio/SFX/Newstufftoadd/lilypadimpact_-8dB.wav"]],
	# unimplemented splash sizes based on frog mass
	"splash_small": [-6, -5, 1, 0.6, 1.5, ["res://Assets/Audio/SFX/splash_small_-6dB.wav"]],
	"splash_large": [-6, -5, 1, 0.6, 1.5, ["res://Assets/Audio/SFX/splash_big_-6dB.wav"]],
}

# key to audio_configs[0-5]: 0: dbset, 1: dbmin, 2: dbmax, 3: pitchmin,4: pitchmax, 5: audiopaths (array of string(s))
	# [0] dbset is volume!                                                
	# [1] dbmin is most that could be subtracted from db using randomizer!
	# [2] dbmax is most that could be added to db        using randomizer! (consider log scale: same abs value has larger impact than min)
	# [3] pitchmin is most pitch would be decreased      using randomizer! ex: 0.5 means frequencies halved (octave down)
	# [4] pitchmax is most pitch would be increased      using randomizer! ex: 2 means frequencies doubled (octave up)
	# [5] is array of possible file paths!                                 get by copying path of file
	# recommended initial settings: [0, -4, 2, 0.85, 1.2, ["path(s)"]]
	
# 2) VARIABLES AND UTILS
var rng = RandomNumberGenerator.new() # usded to determine pitch/db offset, filepath if multiple
var roundrobin = 1 # used by SFX player, expected value 1-n where n is max sfx players (13 as of 10-9-24)

# is-on to db converter
func bool_to_db(on : bool) -> int:
	if !on:
		return -60
	else:
		return -3

# establish BUSES

# master bus
var masterbus = AudioServer.get_bus_index("Master")

# MUSIC BUSES
# music bus to collect main theme and shop theme (used by music slider)
var musicbusall = AudioServer.get_bus_index("MXALL")
# music bus for main theme (for switching between shop and main)
var themebus = AudioServer.get_bus_index("MXLAYERS")
# music bus for just shop music
var shopbus = AudioServer.get_bus_index("MXSHOP")

# SFX BUS
var fxbus = AudioServer.get_bus_index("SFX")

# ATM BUS
var atmbus = AudioServer.get_bus_index("ATM")

# LAYER STREAM INIT
# setup onready for sync stream... i copied this dunno whats going on. praying to the Lord this works
@onready var audio_stream_player : AudioStreamPlayer = $PickupMXTheme
@onready var audio_stream : AudioStreamSynchronized = audio_stream_player.stream


# 3) AMBIANCE

# setup ambiance
func _ready() -> void:
	set_ambiance_on(true)
# toggle (not used yet)
func set_ambiance_on(on : bool) -> void:
	if on:
		$PickupATM.play()
	else:
		$PickupATM.stop()


# 4) MUSIC

# this function is called when level begins to start or re-start music
func play_base_music(on : bool) -> void:
	if !on:
		$PickupMXTheme.stop()
		$PickupMXShop.stop()
		return
	
	$PickupMXTheme.play()
	$PickupMXShop.play()

	# mute non-base sync streams
	audio_stream.set_sync_stream_volume(1,-60)
	audio_stream.set_sync_stream_volume(2,-60)
	audio_stream.set_sync_stream_volume(3,-60)
	audio_stream.set_sync_stream_volume(4,-60)
	AudioServer.set_bus_mute(shopbus, true)
	#

# dynamic music layer system 
func change_music_layer(layer : int):
	var musiclayerdivisions = [2,4,6,8] # the first tallest tower height in which the next music layer is played
	if layer < musiclayerdivisions[0]: # only base layer plays      
		audio_stream.set_sync_stream_volume(1,bool_to_db(false))
		audio_stream.set_sync_stream_volume(2,bool_to_db(false))
		audio_stream.set_sync_stream_volume(3,bool_to_db(false))
		audio_stream.set_sync_stream_volume(4,bool_to_db(false))
	elif layer < musiclayerdivisions[1]: # only first two layers play
		audio_stream.set_sync_stream_volume(1,bool_to_db(true))
		audio_stream.set_sync_stream_volume(2,bool_to_db(false))
		audio_stream.set_sync_stream_volume(3,bool_to_db(false))
		audio_stream.set_sync_stream_volume(4,bool_to_db(false))
	elif layer < musiclayerdivisions[2]: # only first three layers play
		audio_stream.set_sync_stream_volume(1,bool_to_db(true))
		audio_stream.set_sync_stream_volume(2,bool_to_db(true))
		audio_stream.set_sync_stream_volume(3,bool_to_db(false))
		audio_stream.set_sync_stream_volume(4,bool_to_db(false))
	elif layer < musiclayerdivisions[3]: # only first four layers play
		audio_stream.set_sync_stream_volume(1,bool_to_db(true))
		audio_stream.set_sync_stream_volume(2,bool_to_db(true))
		audio_stream.set_sync_stream_volume(3,bool_to_db(true))
		audio_stream.set_sync_stream_volume(4,bool_to_db(false))
	else: # all layers play
		audio_stream.set_sync_stream_volume(1,bool_to_db(true))
		audio_stream.set_sync_stream_volume(2,bool_to_db(true))
		audio_stream.set_sync_stream_volume(3,bool_to_db(true))
		audio_stream.set_sync_stream_volume(4,bool_to_db(true))

# toggle shop / main theme
func shop_music(is_playing : bool):
	AudioServer.set_bus_mute(shopbus, !is_playing)
	AudioServer.set_bus_mute(themebus, is_playing)


# 5) SFX

# intake calls from elsewhere in code
# match string in sound_configs dictionary
func play_sfx(name : String):
	# check if called effect is in config list
	if sound_config.has(name):
		# sound found
		# check for valid path
		if sound_config[name][5] == ["null"]:
			print("Thank you for implementing the " + name + " sound effect! a path will be created soon!!!!")
		# call sfx manager 
		sfx_manager(sound_config[name])  # Access the value if the key exists
	else: # sound not found
		print("sound_manager could not find configs for \"", name, "\".")

# configure one of 13 rotating players to play called sound 
func sfx_manager(audio_configs : Array) -> void:
	# choose from set of paths if possible
	var audiopathnum = randi_range(0, audio_configs[5].size()-1)
	# select chosen path
	var newsound = load(audio_configs[5][audiopathnum])
	# select roundrobin:
	match roundrobin: 
		1:
			roundrobin += 1
			#print("egg")
			$PickupSFX1.set_stream(newsound)
			$PickupSFX1.pitch_scale = rng.randf_range(audio_configs[3], audio_configs[4])
			$PickupSFX1.volume_db = audio_configs[0] + rng.randf_range(audio_configs[1], audio_configs[2])
			#choose player from round robin
			$PickupSFX1.play()
		2:
			roundrobin += 1
			$PickupSFX2.set_stream(newsound)
			$PickupSFX2.pitch_scale = rng.randf_range(audio_configs[3], audio_configs[4])
			$PickupSFX2.volume_db = audio_configs[0] + rng.randf_range(audio_configs[1], audio_configs[2])
			#choose player from round robin
			$PickupSFX2.play()
		3:
			roundrobin += 1
			$PickupSFX3.set_stream(newsound)
			$PickupSFX3.pitch_scale = rng.randf_range(audio_configs[3], audio_configs[4])
			$PickupSFX3.volume_db = audio_configs[0] + rng.randf_range(audio_configs[1], audio_configs[2])
			#choose player from round robin
			$PickupSFX3.play()
		4:
			roundrobin += 1
			$PickupSFX4.set_stream(newsound)
			$PickupSFX4.pitch_scale = rng.randf_range(audio_configs[3], audio_configs[4])
			$PickupSFX4.volume_db = audio_configs[0] + rng.randf_range(audio_configs[1], audio_configs[2])
			#choose player from round robin
			$PickupSFX4.play()
		5:
			roundrobin += 1
			$PickupSFX5.set_stream(newsound)
			$PickupSFX5.pitch_scale = rng.randf_range(audio_configs[3], audio_configs[4])
			$PickupSFX5.volume_db = audio_configs[0] + rng.randf_range(audio_configs[1], audio_configs[2])
			#choose player from round robin
			$PickupSFX5.play()
		6:
			roundrobin += 1
			$PickupSFX6.set_stream(newsound)
			$PickupSFX6.pitch_scale = rng.randf_range(audio_configs[3], audio_configs[4])
			$PickupSFX6.volume_db = audio_configs[0] + rng.randf_range(audio_configs[1], audio_configs[2])
			#choose player from round robin
			$PickupSFX6.play()
		7:
			roundrobin += 1
			$PickupSFX7.set_stream(newsound)
			$PickupSFX7.pitch_scale = rng.randf_range(audio_configs[3], audio_configs[4])
			$PickupSFX7.volume_db = audio_configs[0] + rng.randf_range(audio_configs[1], audio_configs[2])
			#choose player from round robin
			$PickupSFX7.play()
		8:
			roundrobin += 1
			$PickupSFX8.set_stream(newsound)
			$PickupSFX8.pitch_scale = rng.randf_range(audio_configs[3], audio_configs[4])
			$PickupSFX8.volume_db = audio_configs[0] + rng.randf_range(audio_configs[1], audio_configs[2])
			#choose player from round robin
			$PickupSFX8.play()
		9:
			roundrobin += 1
			$PickupSFX9.set_stream(newsound)
			$PickupSFX9.pitch_scale = rng.randf_range(audio_configs[3], audio_configs[4])
			$PickupSFX9.volume_db = audio_configs[0] + rng.randf_range(audio_configs[1], audio_configs[2])
			#choose player from round robin
			$PickupSFX9.play()
		10:
			roundrobin += 1
			$PickupSFX10.set_stream(newsound)
			$PickupSFX10.pitch_scale = rng.randf_range(audio_configs[3], audio_configs[4])
			$PickupSFX10.volume_db = audio_configs[0] + rng.randf_range(audio_configs[1], audio_configs[2])
			#choose player from round robin
			$PickupSFX10.play()
		11:
			roundrobin += 1
			$PickupSFX11.set_stream(newsound)
			$PickupSFX11.pitch_scale = rng.randf_range(audio_configs[3], audio_configs[4])
			$PickupSFX11.volume_db = audio_configs[0] + rng.randf_range(audio_configs[1], audio_configs[2])
			#choose player from round robin
			$PickupSFX11.play()
		12:
			roundrobin += 1
			$PickupSFX12.set_stream(newsound)
			$PickupSFX12.pitch_scale = rng.randf_range(audio_configs[3], audio_configs[4])
			$PickupSFX12.volume_db = audio_configs[0] + rng.randf_range(audio_configs[1], audio_configs[2])
			#choose player from round robin
			$PickupSFX12.play()
		13:
		
			roundrobin = 1
			$PickupSFX13.set_stream(newsound)
			$PickupSFX13.pitch_scale = rng.randf_range(audio_configs[3], audio_configs[4])
			$PickupSFX13.volume_db = audio_configs[0] + rng.randf_range(audio_configs[1], audio_configs[2])
			#choose player from round robin
			$PickupSFX13.play()
			#print("round robin!")


# 6) BUS MANAGEMENT

# master bus manager
#  get val from slider
func _on_main_slider_mouse_exited() -> void:
	$AudioManagerControls/HBoxContainer/VBoxContainer/MainSlider.release_focus()
# change bus to slider val (db rectified slider range is 0-1)
func _on_main_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(masterbus,linear_to_db(value))
func _on_main_toggle_pressed() -> void:
	AudioServer.set_bus_mute(masterbus, not AudioServer.is_bus_mute(masterbus))

# music bus manager
# note: this is for the UI, modifies main music bus not individual parts
# get val from slider
func _on_mx_slider_mouse_exited() -> void:
	$AudioManagerControls/HBoxContainer/VBoxContainer/MXSlider.release_focus()
# change bus to slider val (db rectified slider range is 0-1)
func _on_mx_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(musicbusall,linear_to_db(value))
# toggle mx
func _on_mx_toggle_pressed() -> void:
	AudioServer.set_bus_mute(musicbusall, not AudioServer.is_bus_mute(musicbusall))

# fx bus manager
# get val from slider
func _on_fx_slider_mouse_exited() -> void:
	$AudioManagerControls/HBoxContainer/VBoxContainer/FXSlider.release_focus()
# change bus to slider val (db rectified slider range is 0-1)
func _on_fx_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(fxbus,linear_to_db(value))
# toggle sfx
func _on_fx_toggle_pressed() -> void:
	AudioServer.set_bus_mute(fxbus, not AudioServer.is_bus_mute(fxbus))

# atm bus manager
# get val from slider
func _on_atm_slider_mouse_exited() -> void:
	$AudioManagerControls/HBoxContainer/VBoxContainer/ATMSlider.release_focus()
# change bus to slider val (db rectified slider range is 0-1)
func _on_atm_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(atmbus,linear_to_db(value))
# toggle atm
func _on_atm_toggle_pressed() -> void:
	AudioServer.set_bus_mute(atmbus, not AudioServer.is_bus_mute(atmbus))
