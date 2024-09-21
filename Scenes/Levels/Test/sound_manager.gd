extends Node2D

# this code was made by brendan so enter at ur own risk
# TOC:
# Variables/Utils COMPLETE
# Music STILL NEEDS LAYER SWITCHING LOGIC
# Bus management
# SFX management 

# VARIABLES AND UTILS

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
	$PickupATM.play()
	# mute time for non-base layer buses
	AudioServer.set_bus_mute(musicbus2, not AudioServer.is_bus_mute(musicbus2))
	AudioServer.set_bus_mute(musicbus3, not AudioServer.is_bus_mute(musicbus3))
	AudioServer.set_bus_mute(musicbus4, not AudioServer.is_bus_mute(musicbus4))
	AudioServer.set_bus_mute(musicbus5, not AudioServer.is_bus_mute(musicbus5))
	# surely this method of muting will not cause problems later. pause for comedic effect	

# code here for changing layers
# move to bus management section
# pseudocode:
#func musiclayerchange(lay) -> void:
	# ya i cannot comprehend this right now. only code.
	# perhaps this should be a variable declared in utils so muting/unmuting can be done with reference to previous state... i think the mute code i have been using is toggle


# BUS MANAGEMENT


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

# example call:
func sfx_manager_example() -> void:
	# first is file name, get by copying path of file
	# second is volume! average db, 0 by default
	# third is db minimum! most that could be subtracted from db using randmomizer
	# fourth is db max! most that can be added to db using randomizer, should be smaller abs value than min
	# fifth is pitch min! 0.5 value would mean frequencies halved (lower pitch)
	# sixth is pitch max! 2 means an octave up
	# here is an example of a call with my default values plugged in
	sfx_manager("res://Assets/Audio/ribbit2.wav",0,-4,2,0.85,1.2)
	
func sfx_manager(audiopath,dbset,dbmin,dbmax,pitchmin,pitchmax) -> void:
	var newsound = load(audiopath)
	$PickupSFX.set_stream(newsound)
	$PickupSFX.pitch_scale = rng.randf_range(pitchmin, pitchmax)
	$PickupSFX.volume_db = dbset + rng.randf_range(dbmin, dbmax)
	$PickupSFX.play()
	
	# only one player rn, can duplicate and implement round robin system
	
