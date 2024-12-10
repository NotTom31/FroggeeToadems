class_name SoundManager
extends Node2D

# brendan's beautiful perfect code

# TABLE OF CONTENTS:
# 1) AUDIO CONFIGS (~28)
	# audio paths and customizations for db, pitch, etc set
# 2) VARIABLES/UTILS: (~84)
	# mute/unmute levels
	# fade in / fade out time constants
	# randomizer and round robin variable
	# mx fade state manager
	# buses are initialized
# 3) AMBIANCE: (~171)
# 4) MUSIC: (~184)
	# play music on level start
	# dynamic music layer system
	# toggle shop / main
	# music fader
# 5) SFX: (~297)
	# take calls from elsewhere in code
	# check audio configs
	# round-robin style player
# 6) BUS MANAGEMENT: (~418)
	# logic used for volume sliders in settings menu 



# 1) AUDIO CONFIGS
# this portion of code is where volume, volume variety, and pitch variety are set for each effect
# additionally, the configs audio file path(s) are specified
# key can be found below array
# NOTE! filepaths ["null] indicate a planned sound effect not yet implemented
# the debugger will return a message confirming implementation if and only if the filepath says ["null"]
var sound_config = {
	# UI
	"menu_click": [-6, -2, 1, 1, 0.85, 1.2, ["res://Assets/Audio/SFX/Newstufftoadd/click1_-6dB.wav", "res://Assets/Audio/SFX/Newstufftoadd/click2_-6dB.wav"]],
	"menu_hover": [-18, -3, 1, 1, 0.8, 1.3, ["res://Assets/Audio/SFX/Newstufftoadd/hoverclick1_-7dB.wav", "res://Assets/Audio/SFX/Newstufftoadd/hoverclick2_-7dB.wav"]],
	# planned ui:
	"open_spellbook": [0, -4, 2, 1, 0.85, 1.2, ["null"]],
	"close_spellbook": [0, -4, 2, 1, 0.85, 1.2, ["null"]],
	"open_shop": [0, -4, 2, 1, 0.85, 1.2, ["null"]],
	"close_shop": [0, -4, 2, 1, 0.85, 1.2, ["null"]],
	# FROG SFX
	"boing1": [-8, -4, 2, 1, 0.7, 1.3, ["res://Assets/Audio/SFX/boing_1_-7dB.wav","res://Assets/Audio/SFX/boing_2_-7dB.wav","res://Assets/Audio/SFX/boing_3_-7dB.wav","res://Assets/Audio/SFX/boing_4_-7dB.wav"]],
	#"bounce_charge_slow": [1, -4, 2, 1, 0.85, 1.2, ["res://Assets/Audio/SFX/post-jam addition/bouncecharge3.wav"]],
	#"bounce_charge_medium": [1, -4, 2, 1, 0.85, 1.2, ["res://Assets/Audio/SFX/post-jam addition/bouncecharge3faster.wav"]],
	#"bounce_charge_fast": [2, -4, 2, 1, 0.85, 1.2, ["res://Assets/Audio/SFX/post-jam addition/bouncecharge3fastest.wav"]],
	"wert_slow": [0, -4, 2, 1, 0.85, 1.2, ["res://Assets/Audio/SFX/post-jam addition/wert.wav"]],
	"wert_medium": [0, -4, 2, 1, 0.85, 1.2, ["res://Assets/Audio/SFX/post-jam addition/wertmedium.wav"]],
	"wert_fast": [2, -4, 2, 1, 0.85, 1.2, ["res://Assets/Audio/SFX/post-jam addition/wertfastest.wav"]],
	"wert": [0, -4, 2, 1, 0.85, 1.2, ["res://Assets/Audio/SFX/post-jam addition/wert.wav", "res://Assets/Audio/SFX/post-jam addition/wertmedium.wav", "res://Assets/Audio/SFX/post-jam addition/wertfastest.wav"]],
	# unimplemented sound "frog_click" for when clicking on frogs
	"frog_click": [7, -4, 2, 1, 0.85, 1.2, ["res://Assets/Audio/SFX/frogimpact1.wav","res://Assets/Audio/SFX/frogimpact2.wav"]],
	# planned sound "frog_spawn" for when a new frog appears
	"frog_spawn": [-5, -4, 2, 1, 0.8, 1.4, ["res://Assets/Audio/SFX/post-jam addition/spawn_poof2686.wav"]],
	"frog_snap": [-1, -4, 2, 1, 0.85, 1.2, ["res://Assets/Audio/SFX/post-jam addition/frogsnap1.wav", "res://Assets/Audio/SFX/post-jam addition/frogsnap2.wav", "res://Assets/Audio/SFX/post-jam addition/frogsnap3.wav"]],
	"tiny_ribbit" : [-15, -4, 2, 1, 0.85, 1.2, ["res://Assets/Audio/SFX/ribbit_tiny1_-9dB.wav","res://Assets/Audio/SFX/ribbit_tiny2_-9dB.wav","res://Assets/Audio/SFX/ribbit_tiny3_-9dB.wav"]],
	"default_ribbit": [-1, -4, 2, 1, 0.85, 1.2, ["res://Assets/Audio/SFX/post-jam addition/ribbit_normal.wav"]],
	"tropical_ribbit": [-1, -4, 2, 1, 0.85, 1.2, ["res://Assets/Audio/SFX/post-jam addition/ribbit_tropical.wav"]],
	"big_ribbit": [-8, -4, 2, 1, 0.85, 1.2, ["res://Assets/Audio/SFX/ribbitBIG_-8dB.wav"]],
	# MAGIC SFX
	"magic" : [-3, -4, 2, 1, 0.85, 1.2, ["res://Assets/Audio/SFX/post-jam addition/magic1.wav", "res://Assets/Audio/SFX/post-jam addition/magic2.wav", "res://Assets/Audio/SFX/post-jam addition/magic3.wav"]],
	"magic_equip" : [-10, -4, 2, 1, 0.85, 1.2, ["res://Assets/Audio/SFX/post-jam addition/magicequip.wav", "res://Assets/Audio/SFX/post-jam addition/magicequip2.wav"]],
	"magic_unequip" : [-10, -4, 2, 1, 0.85, 1.2, ["res://Assets/Audio/SFX/post-jam addition/magicunequip.wav"]],
	"magic_fail" : [1, -4, 2, 1, 0.85, 1.2, ["res://Assets/Audio/SFX/post-jam addition/magicfail1.wav", "res://Assets/Audio/SFX/post-jam addition/magicfail2.wav"]],
	# NPCS
	# purrzerk lvl 1
	# deeper voice
	"beep_text0": [-9, -4, 5, 0.66, 0.9, 1.2, ["res://Assets/Audio/SFX/GWJ73_SFX_beepText_loop_-7dB.wav","res://Assets/Audio/SFX/beepText3-7dB.wav","res://Assets/Audio/SFX/beepText4-7dB.wav"]],
	# mask cat lvl 2
	# add filtered meow sound
	"beep_text1": [-9, -4, 5, 1, 0.85, 1.3, ["res://Assets/Audio/SFX/GWJ73_SFX_beepText_loop_-7dB.wav","res://Assets/Audio/SFX/beepText3-7dB.wav","res://Assets/Audio/SFX/beepText4-7dB.wav"]],
	# chuddly lvl 3
	# add custom meows
	"beep_text2": [-9, -4, 5, 1, 0.5, 1.3, ["res://Assets/Audio/SFX/GWJ73_SFX_beepText_loop_-7dB.wav","res://Assets/Audio/SFX/beepText3-7dB.wav","res://Assets/Audio/SFX/beepText4-7dB.wav"]],
	# gorf lvl 4
	# ribbit / meow hybrid, needs update
	"beep_text3": [-3, -4, 5, 1, 0.7, 1.3, ["res://Assets/Audio/SFX/gorf_meow_mockup1.wav", "res://Assets/Audio/SFX/gorf_meow_mockup2.wav", "res://Assets/Audio/SFX/gorf_meow_mockup3.wav"]],
	# pestarzt lvl 5
	# custom mask sound
	"beep_text4": [-4, -4, 5, 0.7, 0.7, 1.3, ["res://Assets/Audio/SFX/Pestarzt_beep_new.wav"]],#"res://Assets/Audio/SFX/Pestarzt_beep1.wav","res://Assets/Audio/SFX/Pestarzt_beep2.wav","res://Assets/Audio/SFX/Pestarzt_beep3.wav"]],
	# void cat lvl 6
	# high pitched
	"beep_text5": [-9, -4, 5, 2.6, 0.98, 1.05, ["res://Assets/Audio/SFX/GWJ73_SFX_beepText_loop_-7dB.wav","res://Assets/Audio/SFX/beepText3-7dB.wav","res://Assets/Audio/SFX/beepText4-7dB.wav"]],
	# minnum cat
	# deep meow
	"beep_text6": [-9, -4, 5, 0.2, 0.5, 1.25, ["res://Assets/Audio/SFX/beepText4-7dB.wav"]],
	# ?
	"beep_text7": [-9, -4, 5, 1.3, 0.7, 1.3, ["res://Assets/Audio/SFX/GWJ73_SFX_beepText_loop_-7dB.wav","res://Assets/Audio/SFX/beepText3-7dB.wav","res://Assets/Audio/SFX/beepText4-7dB.wav"]],
	#tac
	"beep_text8": [-9, -4, 5, 1, 0.7, 1.3, ["res://Assets/Audio/SFX/GWJ73_SFX_beepText_loop_-7dB.wav","res://Assets/Audio/SFX/beepText3-7dB.wav","res://Assets/Audio/SFX/beepText4-7dB.wav"]],
		#OTHER
	"splash_med": [-6, -5, 1, 1, 0.6, 1.5, ["res://Assets/Audio/SFX/splash_medium_-6dB.wav"]],
	"lillypad_impact": [0, -4, 2, 1, 0.85, 1.2, ["res://Assets/Audio/SFX/Newstufftoadd/lilypadimpact_-8dB.wav"]],
	# unimplemented splash sizes based on frog mass
	"splash_small": [-6, -5, 1, 1, 0.6, 1.5, ["res://Assets/Audio/SFX/splash_small_-6dB.wav"]],
	"splash_large": [-6, -5, 1, 1, 0.6, 1.5, ["res://Assets/Audio/SFX/splash_big_-6dB.wav"]],
}

# key to audio_configs[0-5]: 0: dbset, 1: dbmin, 2: dbmax, 3: pitchmin,4: pitchmax, 5: audiopaths (array of string(s))
	# [0] dbset is volume!                                                
	# [1] dbmin is most that could be subtracted from db using randomizer!
	# [2] dbmax is most that could be added to db        using randomizer! (consider log scale: same abs value has larger impact than min)
	# [3] pitchset is pitch!
	# [4] pitchmin is most pitch would be decreased      using randomizer! ex: 0.5 means frequencies halved (octave down)
	# [5] pitchmax is most pitch would be increased      using randomizer! ex: 2 means frequencies doubled (octave up)
	# [6] is array of possible file paths!                                 get by copying path of file
	# recommended initial settings: [0, -4, 2, 1, 0.85, 1.2, ["path(s)"]]
	
# 2) VARIABLES AND UTILS

# mute and unmute volumes
var mxvolumemute = -60
var mxvolumemax = -3

# time constants to determine fade in/out speed. replace if converting from linear to log fades
var fade_in_speed = 120
var fade_out_speed = 15
var fade_in_speed_layers = 40
var fade_out_speed_layers = 9

# rng
var rng = RandomNumberGenerator.new() # usded to determine pitch/db offset, filepath if multiple

# is-on to db converter
func bool_to_db(on : bool) -> int:
	if !on:
		return mxvolumemute
	else:
		return mxvolumemax

#is on to bin converter
func bool_to_bin(on : bool) -> int:
	if !on:
		return 0
	else:
		return 1

var roundrobin = 1 # used by SFX player, expected value 1-n where n is max sfx players (13 as of 10-9-24)


# LAYER STREAM INIT
# setup onready for sync stream... i copied this dunno whats going on. praying to the Lord this works
@onready var audio_stream_player : AudioStreamPlayer = $PickupMXTheme
@onready var audio_stream : AudioStreamSynchronized = audio_stream_player.stream

# music fade in/out
#var cossfade_length = 0.5
#var crossfade_delta = 0.05
var fade_in_tracker = [0, 0, 0, 0, 0, 0, 0] # layers 0-4, 5 theme bus, 6 shop bus
var fade_out_tracker = [0, 0, 0, 0, 0, 0, 0]
#var fade_controls = [0,0,0,0,0,$PickupMXShop.volume_db]

# fade manager
# handle calls from within manager to initiate a fade. Toggles in-prog fade out if fade in called and vice versa
func mx_fader(track : int, fade_type : int):
	# fade_type 1 is fade in, 0 is fade out
	if fade_type == 1:
		# fade in
		fade_in_tracker[track] = 1
		fade_out_tracker[track] = 0
		#print("fading in track" + str(track))
		# handle bus management if appropriate
		if track == 5:
			AudioServer.set_bus_mute(themebus, false)
		elif track == 6:
			AudioServer.set_bus_mute(shopbus, false)
	if fade_type == 0:
		# fade out
		fade_in_tracker[track] = 0
		fade_out_tracker[track] = 1
		#print("fading out track" + str(track))

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

# EFFECTS # unused atm
#var lopass = AudioServer.get_bus_effect(1, 0)


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
	$PickupMXShop.volume_db = mxvolumemute
	$PickupMXTheme.volume_db = mxvolumemute
	
	#unused effect init
	# turn off lopass by default
	#lopass.cutoff_hz = 999999
	#

# dynamic music layer system 
func change_music_layer(layer : int):
	var musiclayerdivisions = [2,4,6,8] # the first tallest tower height in which the next music layer is played
	if layer < musiclayerdivisions[0]: # only base layer plays      
		mx_fader(1,0)
		mx_fader(2,0)
		mx_fader(3,0)
		mx_fader(4,0)

	elif layer < musiclayerdivisions[1]: # only first two layers play
		mx_fader(1,1)
		mx_fader(2,0)
		mx_fader(3,0)
		mx_fader(4,0)
	elif layer < musiclayerdivisions[2]: # only first three layers play
		mx_fader(1,1)
		mx_fader(2,1)
		mx_fader(3,0)
		mx_fader(4,0)
	elif layer < musiclayerdivisions[3]: # only first four layers play
		mx_fader(1,1)
		mx_fader(2,1)
		mx_fader(3,1)
		mx_fader(4,0)
	else: # all layers play
		mx_fader(1,1)
		mx_fader(2,1)
		mx_fader(3,1)
		mx_fader(4,1)

# toggle shop / main theme
func shop_music(is_playing : bool):
	mx_fader(6,bool_to_bin(is_playing)) # shop bus toggle/untoggle fade
	#AudioServer.set_bus_mute(shopbus, !is_playing)
	mx_fader(5,bool_to_bin(!is_playing)) # theme bus toggle/untoggle
	#AudioServer.set_bus_mute(themebus, is_playing)

#music fade manager
#handles fades based on fade controller. Ends fade state upon completion
func _process(delta: float) -> void:
	# check theme / shop
	# theme overall
	if fade_in_tracker[5] == 1:
		$PickupMXTheme.volume_db += fade_in_speed*delta
		if $PickupMXTheme.volume_db >= mxvolumemax:
			fade_in_tracker[5] = 0
			#print("theme fade in complete")
	if fade_out_tracker[5] == 1:
		AudioServer.set_bus_mute(themebus, false)
		$PickupMXTheme.volume_db -= fade_out_speed*delta
		if $PickupMXTheme.volume_db <= mxvolumemute:
			fade_out_tracker[5] = 0
			AudioServer.set_bus_mute(themebus, true)
			#print("theme fade out complete")
	# shop overall
	if fade_in_tracker[6] == 1:
		$PickupMXShop.volume_db += fade_in_speed*delta
		if $PickupMXShop.volume_db >= mxvolumemax:
			fade_in_tracker[6] = 0
			#print("shop fade in complete")
	if fade_out_tracker[6] == 1:
		AudioServer.set_bus_mute(shopbus, false)
		$PickupMXShop.volume_db -= fade_out_speed*delta
		if $PickupMXShop.volume_db <= mxvolumemute:
			fade_out_tracker[6] = 0
			AudioServer.set_bus_mute(shopbus, true)
			#print("shop fade out complete")
	# check individual music layers
	for n in [0,1,2,3,4]:
		if fade_in_tracker[n] == 1:
			audio_stream.set_sync_stream_volume(n, audio_stream.get_sync_stream_volume(n)+fade_in_speed_layers*delta)
			if audio_stream.get_sync_stream_volume(n) >= mxvolumemax:
				audio_stream.set_sync_stream_volume(n, mxvolumemax)
				fade_in_tracker[n] = 0
				#print("layer " + str(n) + " faded in")
		if fade_out_tracker[n] == 1:
			audio_stream.set_sync_stream_volume(n, audio_stream.get_sync_stream_volume(n)-fade_out_speed_layers*delta)
			if audio_stream.get_sync_stream_volume(n) <= mxvolumemute:
				audio_stream.set_sync_stream_volume(n, mxvolumemute)
				fade_out_tracker[n] = 0
				#print("layer " + str(n) + " faded out")
	#if get_tree().paused == true:
		#print("paused")
# scrapping lo pass for pause for now
#func pause_screen(is_paused : bool):
	##set_bus_effect_enabled(bus_idx: int, effect_idx: int, enabled: bool)
	#lopass.cutoff_hz = bool_to_bin(is_paused)*99999 + 2000
	


# 5) SFX

# intake calls from elsewhere in code
# match string in sound_configs dictionary
func play_sfx(name : String):
	# check if called effect is in config list
	if sound_config.has(name):
		# sound found
		# check for valid path
		if sound_config[name][6] == ["null"]:
			print("Thank you for implementing the " + name + " sound effect! a path will be created soon!!!!")
		# call sfx manager 
		sfx_manager(sound_config[name])  # Access the value if the key exists
	else: # sound not found
		print("sound_manager could not find configs for \"", name, "\".")

# configure one of 13 rotating players to play called sound 
func sfx_manager(audio_configs : Array) -> void:
	# choose from set of paths if possible
	var audiopathnum = randi_range(0, audio_configs[6].size()-1)
	# select chosen path
	var newsound = load(audio_configs[6][audiopathnum])
	# select roundrobin:
	match roundrobin: 
		1:
			roundrobin += 1
			#print("egg")
			$PickupSFX1.set_stream(newsound)
			$PickupSFX1.pitch_scale = audio_configs[3] * rng.randf_range(audio_configs[4], audio_configs[5])
			$PickupSFX1.volume_db = audio_configs[0] + rng.randf_range(audio_configs[1], audio_configs[2])
			#choose player from round robin
			$PickupSFX1.play()
		2:
			roundrobin += 1
			$PickupSFX2.set_stream(newsound)
			$PickupSFX2.pitch_scale = audio_configs[3] * rng.randf_range(audio_configs[4], audio_configs[5])
			$PickupSFX2.volume_db = audio_configs[0] + rng.randf_range(audio_configs[1], audio_configs[2])
			#choose player from round robin
			$PickupSFX2.play()
		3:
			roundrobin += 1
			$PickupSFX3.set_stream(newsound)
			$PickupSFX3.pitch_scale = audio_configs[3] * rng.randf_range(audio_configs[4], audio_configs[5])
			$PickupSFX3.volume_db = audio_configs[0] + rng.randf_range(audio_configs[1], audio_configs[2])
			#choose player from round robin
			$PickupSFX3.play()
		4:
			roundrobin += 1
			$PickupSFX4.set_stream(newsound)
			$PickupSFX4.pitch_scale = audio_configs[3] * rng.randf_range(audio_configs[4], audio_configs[5])
			$PickupSFX4.volume_db = audio_configs[0] + rng.randf_range(audio_configs[1], audio_configs[2])
			#choose player from round robin
			$PickupSFX4.play()
		5:
			roundrobin += 1
			$PickupSFX5.set_stream(newsound)
			$PickupSFX5.pitch_scale = audio_configs[3] * rng.randf_range(audio_configs[4], audio_configs[5])
			$PickupSFX5.volume_db = audio_configs[0] + rng.randf_range(audio_configs[1], audio_configs[2])
			#choose player from round robin
			$PickupSFX5.play()
		6:
			roundrobin += 1
			$PickupSFX6.set_stream(newsound)
			$PickupSFX6.pitch_scale = audio_configs[3] * rng.randf_range(audio_configs[4], audio_configs[5])
			$PickupSFX6.volume_db = audio_configs[0] + rng.randf_range(audio_configs[1], audio_configs[2])
			#choose player from round robin
			$PickupSFX6.play()
		7:
			roundrobin += 1
			$PickupSFX7.set_stream(newsound)
			$PickupSFX7.pitch_scale = audio_configs[3] * rng.randf_range(audio_configs[4], audio_configs[5])
			$PickupSFX7.volume_db = audio_configs[0] + rng.randf_range(audio_configs[1], audio_configs[2])
			#choose player from round robin
			$PickupSFX7.play()
		8:
			roundrobin += 1
			$PickupSFX8.set_stream(newsound)
			$PickupSFX8.pitch_scale = audio_configs[3] * rng.randf_range(audio_configs[4], audio_configs[5])
			$PickupSFX8.volume_db = audio_configs[0] + rng.randf_range(audio_configs[1], audio_configs[2])
			#choose player from round robin
			$PickupSFX8.play()
		9:
			roundrobin += 1
			$PickupSFX9.set_stream(newsound)
			$PickupSFX9.pitch_scale = audio_configs[3] * rng.randf_range(audio_configs[4], audio_configs[5])
			$PickupSFX9.volume_db = audio_configs[0] + rng.randf_range(audio_configs[1], audio_configs[2])
			#choose player from round robin
			$PickupSFX9.play()
		10:
			roundrobin += 1
			$PickupSFX10.set_stream(newsound)
			$PickupSFX10.pitch_scale = audio_configs[3] * rng.randf_range(audio_configs[4], audio_configs[5])
			$PickupSFX10.volume_db = audio_configs[0] + rng.randf_range(audio_configs[1], audio_configs[2])
			#choose player from round robin
			$PickupSFX10.play()
		11:
			roundrobin += 1
			$PickupSFX11.set_stream(newsound)
			$PickupSFX11.pitch_scale = audio_configs[3] * rng.randf_range(audio_configs[4], audio_configs[5])
			$PickupSFX11.volume_db = audio_configs[0] + rng.randf_range(audio_configs[1], audio_configs[2])
			#choose player from round robin
			$PickupSFX11.play()
		12:
			roundrobin += 1
			$PickupSFX12.set_stream(newsound)
			$PickupSFX12.pitch_scale = audio_configs[3] * rng.randf_range(audio_configs[4], audio_configs[5])
			$PickupSFX12.volume_db = audio_configs[0] + rng.randf_range(audio_configs[1], audio_configs[2])
			#choose player from round robin
			$PickupSFX12.play()
		13:
		
			roundrobin = 1
			$PickupSFX13.set_stream(newsound)
			$PickupSFX13.pitch_scale = audio_configs[3] * rng.randf_range(audio_configs[4], audio_configs[5])
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
	play_sfx("menu_click")
# click sound when first dragging
func _on_main_slider_focus_entered() -> void:
	play_sfx("menu_click")
func _on_main_slider_focus_exited() -> void:
	play_sfx("menu_click")
# hover sounds
func _on_main_slider_mouse_entered() -> void:
	play_sfx("menu_hover")
func _on_main_toggle_mouse_entered() -> void:
	play_sfx("menu_hover")

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
	play_sfx("menu_click")
# click sound when dragging
func _on_mx_slider_focus_entered() -> void:
	play_sfx("menu_click")
func _on_mx_slider_focus_exited() -> void:
	play_sfx("menu_click")
# hover sounds
func _on_mx_slider_mouse_entered() -> void:
	play_sfx("menu_hover")
func _on_mx_toggle_mouse_entered() -> void:
	play_sfx("menu_hover")

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
	play_sfx("menu_click")
# click sound when dragging
func _on_fx_slider_focus_entered() -> void:
	play_sfx("menu_click")
func _on_fx_slider_focus_exited() -> void:
	play_sfx("menu_click")
# hover sounds
func _on_fx_slider_mouse_entered() -> void:
	play_sfx("menu_hover")
func _on_fx_toggle_mouse_entered() -> void:
	play_sfx("menu_hover")

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
	play_sfx("menu_click")
# click sound when dragging
func _on_atm_slider_focus_entered() -> void:
	play_sfx("menu_click")
func _on_atm_slider_focus_exited() -> void:
	play_sfx("menu_click")
# hover sounds
func _on_atm_slider_mouse_entered() -> void:
	play_sfx("menu_hover")
func _on_atm_toggle_mouse_entered() -> void:
	play_sfx("menu_hover")
