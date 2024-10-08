class_name SoundManager
extends Node2D

# this code was made by brendan so enter at ur own risk
# TOC:
# Audio Configs
# Variables/Utils COMPLETE
# Music STILL NEEDS LAYER SWITCHING LOGIC
# Bus management
# SFX management 


# AUDIO CONFIGS
# this portion of code is where audio file paths are specified
# additionally, the configs where volume, pitch variety, and volume variety are set
# key to audio_configs[0-5]: 0: dbset, 1: dbmin, 2: dbmax, 3: pitchmin,4: pitchmax, 5: audiopaths (array of string(s))
	# zeroeth is volume! average db, 0 by default
	# first is db minimum! most that could be subtracted from db using randmomizer
	# second is db max! most that can be added to db using randomizer, should be smaller abs value than min
	# third is pitch min! 0.5 value would mean frequencies halved (lower pitch)
	# fourth is pitch max! 2 means an octave up
	# fifth is file name, get by copying path of file

var sound_config = {
	#boing has 4 sound path options
	# key to audio_configs[0-5]: 0: dbset, 1: dbmin, 2: dbmax, 3: pitchmin,4: pitchmax, 5: audiopaths
	"boing1": [-2, -4, 2, 0.7, 1.3, ["res://Assets/Audio/SFX/boing_1_-7dB.wav","res://Assets/Audio/SFX/boing_2_-7dB.wav","res://Assets/Audio/SFX/boing_3_-7dB.wav","res://Assets/Audio/SFX/boing_4_-7dB.wav"]],
	"bounce_charge": [0, -4, 2, 0.85, 1.2, ["res://Assets/Audio/SFX/bounce_charge1_-7dB.wav", "res://Assets/Audio/SFX/bounce_charge2_-7dB.wav"]],
	"frog_snap": [-1, -4, 2, 0.85, 1.2, ["res://Assets/Audio/SFX/frogsnap_-7dB.wav"]],
	"magic" : [0, -4, 2, 0.85, 1.2, ["res://Assets/Audio/SFX/magic5_-5dB.wav"]],
	"tiny_ribbit" : [0, -4, 2, 0.85, 1.2, ["res://Assets/Audio/SFX/ribbit_tiny1_-9dB.wav","res://Assets/Audio/SFX/ribbit_tiny2_-9dB.wav","res://Assets/Audio/SFX/ribbit_tiny3_-9dB.wav"]],
	"default_ribbit": [0, -4, 2, 0.85, 1.2, ["res://Assets/Audio/SFX/ribbit_normal1_-8dB.wav","res://Assets/Audio/SFX/ribbit_normal2_-8dB.wav"]],
	"big_ribbit": [0, -4, 2, 0.85, 1.2, ["res://Assets/Audio/SFX/ribbitBIG_-8dB.wav"]],
	"splash_med": [-6, -5, 1, 0.6, 1.5, ["res://Assets/Audio/SFX/splash_medium_-6dB.wav"]],
	"menu_click": [-4, -2, 1, 0.85, 1.2, ["res://Assets/Audio/SFX/Newstufftoadd/click1_-6dB.wav", "res://Assets/Audio/SFX/Newstufftoadd/click2_-6dB.wav"]],
	"menu_hover": [-18, -3, 1, 0.8, 1.3, ["res://Assets/Audio/SFX/Newstufftoadd/hoverclick1_-7dB.wav", "res://Assets/Audio/SFX/Newstufftoadd/hoverclick2_-7dB.wav"]],
	"lillypad_impact": [0, -4, 2, 0.85, 1.2, ["res://Assets/Audio/SFX/Newstufftoadd/lilypadimpact_-8dB.wav"]],
	"beep_text": [-3, -4, 5, 0.7, 1.3, ["res://Assets/Audio/SFX/GWJ73_SFX_beepText_loop_-7dB.wav"]],
}

# VARIABLES AND UTILS

# establish utils
var rng = RandomNumberGenerator.new()
var roundrobin = 1 # currently general. may need multiple rrs later

# establish variables for bus management
# master bus
var masterbus = AudioServer.get_bus_index("Master")
# music bus to collect main theme and shop theme
var musicbusall = AudioServer.get_bus_index("MXALL")
# music bus to collect different layers of main theme
var musicbuslayers = AudioServer.get_bus_index("MXLAYERS")
# separate buses for all layers - 1 being base with 5 being top layer
var musicbus1 = AudioServer.get_bus_index("MX1")
var musicbus2 = AudioServer.get_bus_index("MX2")
var musicbus3 = AudioServer.get_bus_index("MX3")
var musicbus4 = AudioServer.get_bus_index("MX4")
var musicbus5 = AudioServer.get_bus_index("MX5")
# music bus for just shop music
var shopbus = AudioServer.get_bus_index("MXSHOP")

# sfx bus
var fxbus = AudioServer.get_bus_index("SFX")

# sfx bus
var atmbus = AudioServer.get_bus_index("ATM")

# MUSIC

# play all layers at init. immediately mute all but first layer.
func _ready() -> void:
	set_ambiance_on(true)

func set_ambiance_on(on : bool) -> void:
	if on:
		$PickupATM.play()
	else:
		$PickupATM.stop()

# this function is called when level begins to start or re-start music
func play_base_music(on : bool) -> void:
	if !on:
		$PickupMX1.stop()
		$PickupMX2.stop()
		$PickupMX3.stop()
		$PickupMX4.stop()
		$PickupMX5.stop()
		$PickupMXSHOP.stop()
		return
	
	$PickupMX1.play()
	$PickupMX2.play()
	$PickupMX3.play()
	$PickupMX4.play()
	$PickupMX5.play()
	$PickupMXSHOP.play()
	
	# mute non-base layer buses
	AudioServer.set_bus_mute(musicbus2, not AudioServer.is_bus_mute(musicbus2))
	AudioServer.set_bus_mute(musicbus3, not AudioServer.is_bus_mute(musicbus3))
	AudioServer.set_bus_mute(musicbus4, not AudioServer.is_bus_mute(musicbus4))
	AudioServer.set_bus_mute(musicbus5, not AudioServer.is_bus_mute(musicbus5))
	AudioServer.set_bus_mute(shopbus, not AudioServer.is_bus_mute(shopbus))

# code here for changing layers
# move to bus management section
# pseudocode:
#func musiclayerchange(lay) -> void:
	# ya i cannot comprehend this right now. only code.
	# perhaps this should be a variable declared in utils so muting/unmuting can be done with reference to previous state... i think the mute code i have been using is toggle

# BUS MANAGEMENT
func change_music_layer(layer : int):
	match layer:
		0:
			AudioServer.set_bus_mute(musicbus1, false)
			AudioServer.set_bus_mute(musicbus2, true)
			AudioServer.set_bus_mute(musicbus3, true)
			AudioServer.set_bus_mute(musicbus4, true)
			AudioServer.set_bus_mute(musicbus5, true)
		1:
			AudioServer.set_bus_mute(musicbus1, false)
			AudioServer.set_bus_mute(musicbus2, false)
			AudioServer.set_bus_mute(musicbus3, true)
			AudioServer.set_bus_mute(musicbus4, true)
			AudioServer.set_bus_mute(musicbus5, true)
		2:
			AudioServer.set_bus_mute(musicbus1, false)
			AudioServer.set_bus_mute(musicbus2, false)
			AudioServer.set_bus_mute(musicbus3, false)
			AudioServer.set_bus_mute(musicbus4, true)
			AudioServer.set_bus_mute(musicbus5, true)
		3:
			AudioServer.set_bus_mute(musicbus1, false)
			AudioServer.set_bus_mute(musicbus2, false)
			AudioServer.set_bus_mute(musicbus3, false)
			AudioServer.set_bus_mute(musicbus4, false)
			AudioServer.set_bus_mute(musicbus5, true)
		4:
			AudioServer.set_bus_mute(musicbus1, false)
			AudioServer.set_bus_mute(musicbus2, false)
			AudioServer.set_bus_mute(musicbus3, false)
			AudioServer.set_bus_mute(musicbus4, false)
			AudioServer.set_bus_mute(musicbus5, false)
		_:
			print("Music layer out of bounds")

func shop_music(is_playing : bool):
	AudioServer.set_bus_mute(shopbus, !is_playing)
	AudioServer.set_bus_mute(musicbuslayers, is_playing)


# master bus manager
# idk get val from slider? not sure tbh
func _on_main_slider_mouse_exited() -> void:
	$AudioManagerControls/HBoxContainer/VBoxContainer/MainSlider.release_focus()
# change bus to slider val (db rectified slider range is 0-1)
func _on_main_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(masterbus,linear_to_db(value))
func _on_main_toggle_pressed() -> void:
	AudioServer.set_bus_mute(masterbus, not AudioServer.is_bus_mute(masterbus))

# music bus manager
# note: this is for the UI, modifies main music bus not individual parts
# idk get val from slider? not sure tbh
func _on_mx_slider_mouse_exited() -> void:
	$AudioManagerControls/HBoxContainer/VBoxContainer/MXSlider.release_focus()
# change bus to slider val (db rectified slider range is 0-1)
func _on_mx_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(musicbusall,linear_to_db(value))
# toggle
func _on_mx_toggle_pressed() -> void:
	AudioServer.set_bus_mute(musicbusall, not AudioServer.is_bus_mute(musicbusall))

# fx bus manager
# idk get val from slider? not sure tbh
func _on_fx_slider_mouse_exited() -> void:
	$AudioManagerControls/HBoxContainer/VBoxContainer/FXSlider.release_focus()
# change bus to slider val (db rectified slider range is 0-1)
func _on_fx_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(fxbus,linear_to_db(value))
# toggle
func _on_fx_toggle_pressed() -> void:
	AudioServer.set_bus_mute(fxbus, not AudioServer.is_bus_mute(fxbus))
	
# atm bus manager
# idk get val from slider? not sure tbh
func _on_atm_slider_mouse_exited() -> void:
	$AudioManagerControls/HBoxContainer/VBoxContainer/ATMSlider.release_focus()
# change bus to slider val (db rectified slider range is 0-1)
func _on_atm_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(atmbus,linear_to_db(value))
# toggle
func _on_atm_toggle_pressed() -> void:
	AudioServer.set_bus_mute(atmbus, not AudioServer.is_bus_mute(atmbus))

#SFX MANAGER

# intake calls from elsewhere in code
# match string in dictionary defined at top
func play_sfx(name : String):
	# put try here for debugging
	#call sfx_manager
	sfx_manager(sound_config[name])

# example call: (outdated)
# func sfx_manager_example() -> void:
	

	# here is an example of a call with my default values plugged in
	
func sfx_manager(audio_configs : Array) -> void:
	# choose from set of paths if possible
	var audiopath = randi_range(0, audio_configs[5].size()-1)
	# select chosen path
	var newsound = load(audio_configs[5][audiopath])
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
	

	
