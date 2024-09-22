class_name FrogSpriteHandler
extends Area2D

@export var rest_sprite_position : Vector2
@export var rest_sprite_rotation : float
@export var rest_sprite_scale : Vector2
@export var jump_sprite_position : Vector2
@export var jump_sprite_rotation : float
@export var jump_sprite_scale : Vector2

@export var sprt : AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func play_jump() -> void:
	resize_for_jump()
	sprt.play("jump")

func play_idle() -> void:
	resize_for_rest()
	sprt.play("idle")

func play_blink() -> void:
	resize_for_rest()
	sprt.play("blink")

func resize_for_rest() -> void:
	sprt.position = rest_sprite_position
	sprt.rotation = rest_sprite_rotation
	sprt.scale = rest_sprite_scale

func resize_for_jump() -> void:
	sprt.position = jump_sprite_position
	sprt.rotation = jump_sprite_rotation
	sprt.scale = jump_sprite_scale
