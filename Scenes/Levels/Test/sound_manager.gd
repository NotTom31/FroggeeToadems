extends Node2D

# this code was made by brendan so enter at ur own risk
# TOC:
# Variables/Utils COMPLETE
# Music STILL NEEDS LAYER SWITCHING LOGIC
# Bus management
# SFX management 

# VARIABLES AND UTILS

var sound_paths = {
	"boing1": "res://Assets/Audio/SFX/boing_1_-7dB.wav",
	"bounce_charge": "res://Assets/Audio/SFX/bounce_charge1_-7dB.wav",
	"bounce_charge2": "res://Assets/Audio/SFX/bounce_charge2_-7dB.wav",
	"frog_snap": "res://Assets/Audio/SFX/frogsnap_-7dB.wav",
	"default_ribbit": "res://Assets/Audio/SFX/ribbit6_-8dB.wav",
	"big_ribbit": "res://Assets/Audio/SFX/ribbitBIG_-8dB.wav",
	"ribbit1": "res://Assets/Audio/SFX/ribbit_normal1_-8dB.wav",
	"ribbit2": "res://Assets/Audio/SFX/ribbit_normal2_-8dB.wav",
	"splash_big": "res://Assets/Audio/SFX/splash_big_-6dB.wav",
	"splash_med": "res://Assets/Audio/SFX/splash_medium_-6dB.wav",
	"splash_small": "res://Assets/Audio/SFX/splash_small_-6dB.wav",
	"splash_tiny": "res://Assets/Audio/SFX/splash_tiny_-6dB.wav"
}


# establish utils
var rng = RandomNumberGenerator.new()
var roundrobin = 1 # currently general. may need multiple rrs later

# establish variables for bus management
# master bus
var masterbus = AudioServer.get_bus_index("Master")
# music bus
var musicbusall = AudioServer.get_bus_index("MXALL")
# separate buses for all layers - 1 being base with 5 being top layer. may only need 4
var musicbus1 = AudioServer.get_bus_index("MX1")
var musicbus2 = AudioServer.get_bus_index("MX2")
var musicbus3 = AudioServer.get_bus_index("MX3")
var musicbus4 = AudioServer.get_bus_index("MX4")
var musicbus5 = AudioServer.get_bus_index("MX5")
var shopbus = AudioServer.get_bus_index("MXSHOP")

# sfx bus
var fxbus = AudioServer.get_bus_index("SFX")

# sfx bus
var atmbus = AudioServer.get_bus_index("ATM")

# MUSIC

# play all layers at init. immediately mute all but first layer.
func _ready() -> void:
	$PickupMX1.play()
	$PickupMX2.play()
	$PickupMX3.play()
	$PickupMX4.play()
	$PickupMX5.play()
	$PickupMXSHOP.play()
	$PickupATM.play()
	# mute time for non-base layer buses
	AudioServer.set_bus_mute(musicbus2, not AudioServer.is_bus_mute(musicbus2))
	AudioServer.set_bus_mute(musicbus3, not AudioServer.is_bus_mute(musicbus3))
	AudioServer.set_bus_mute(musicbus4, not AudioServer.is_bus_mute(musicbus4))
	AudioServer.set_bus_mute(musicbus5, not AudioServer.is_bus_mute(musicbus5))
	AudioServer.set_bus_mute(shopbus, not AudioServer.is_bus_mute(shopbus))
	# surely this method of muting will not cause problems later. pause for comedic effect	

# code here for changing layers
# move to bus management section
# pseudocode:
#func musiclayerchange(lay) -> void:
	# ya i cannot comprehend this right now. only code.
	# perhaps this should be a variable declared in utils so muting/unmuting can be done with reference to previous state... i think the mute code i have been using is toggle


#make a copy for each sound
func call_rand_sound():
	var num_of_sounds = 2
	var num = randi_range(1, num_of_sounds)
	match num:
		1:
			print("play first sound")
		2:
			print("play second")
		_:
			print("outside range")


# BUS MANAGEMENT
func change_music_layer(layer : int):
	match layer:
		0:
			AudioServer.set_bus_mute(musicbus2, false)
			AudioServer.set_bus_mute(musicbus3, false)
			AudioServer.set_bus_mute(musicbus4, false)
			AudioServer.set_bus_mute(musicbus5, false)
		1:
			AudioServer.set_bus_mute(musicbus2, true)
			AudioServer.set_bus_mute(musicbus3, false)
			AudioServer.set_bus_mute(musicbus4, false)
			AudioServer.set_bus_mute(musicbus5, false)
		2:
			AudioServer.set_bus_mute(musicbus2, true)
			AudioServer.set_bus_mute(musicbus3, true)
			AudioServer.set_bus_mute(musicbus4, false)
			AudioServer.set_bus_mute(musicbus5, false)
		3:
			AudioServer.set_bus_mute(musicbus2, true)
			AudioServer.set_bus_mute(musicbus3, true)
			AudioServer.set_bus_mute(musicbus4, true)
			AudioServer.set_bus_mute(musicbus5, false)
		4:
			AudioServer.set_bus_mute(musicbus2, true)
			AudioServer.set_bus_mute(musicbus3, true)
			AudioServer.set_bus_mute(musicbus4, true)
			AudioServer.set_bus_mute(musicbus5, true)
		_:
			print("Music layer out of bounds")

func shop_music(is_playing : bool):
	AudioServer.set_bus_mute(shopbus, is_playing)

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

func play_sfx(name : String):
	sfx_manager(name, 0,-4,2,0.85,1.2)

# example call:
func sfx_manager_example() -> void:
	# first is file name, get by copying path of file
	# second is volume! average db, 0 by default
	# third is db minimum! most that could be subtracted from db using randmomizer
	# fourth is db max! most that can be added to db using randomizer, should be smaller abs value than min
	# fifth is pitch min! 0.5 value would mean frequencies halved (lower pitch)
	# sixth is pitch max! 2 means an octave up
	# here is an example of a call with my default values plugged in
	sfx_manager("boing1",0,-4,2,0.85,1.2)
	
func sfx_manager(audiopath,dbset,dbmin,dbmax,pitchmin,pitchmax) -> void:
	var newsound = load(sound_paths[audiopath])
	$PickupSFX.set_stream(newsound)
	$PickupSFX.pitch_scale = rng.randf_range(pitchmin, pitchmax)
	$PickupSFX.volume_db = dbset + rng.randf_range(dbmin, dbmax)
	$PickupSFX.play()
	
	# only one player rn, can duplicate and implement round robin system
	
