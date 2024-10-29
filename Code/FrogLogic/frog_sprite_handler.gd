class_name FrogSpriteHandler
extends Area2D

@export var rest_sprite_position : Vector2
@export var rest_sprite_scale : Vector2
@export var rest_click_rect : Vector2
@export var jump_sprite_position : Vector2
@export var jump_sprite_scale : Vector2
@export var jump_click_rect : Vector2

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

func play_charge() -> void:
	resize_for_rest()
	sprt.play("charge")

func play_ribbit() -> void:
	resize_for_rest()
	if sprt.animation == "idle" || sprt.animation == "blink":
		sprt.play("ribbit")

func resize_for_rest() -> void:
	sprt.position = rest_sprite_position
	sprt.scale = rest_sprite_scale
	$ClickableArea.shape.size = rest_click_rect

func resize_for_jump() -> void:
	sprt.position = jump_sprite_position
	sprt.scale = jump_sprite_scale
	$ClickableArea.shape.size = jump_click_rect
