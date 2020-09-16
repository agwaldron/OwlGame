extends KinematicBody2D

export var CAST_DURATION = 125

onready var animatedSprite = $AnimatedSprite
onready var boltHitBox = $Bolt/CollisionShape2D
onready var sprite_horizontal_offset = 75
onready var cast_timer = CAST_DURATION

func _ready():
	animatedSprite.set_frame(0)

func _process(delta):
	cast_timer -= (delta * 100)
	if cast_timer <= 0:
		queue_free()

func spell_interrupt():
	queue_free()

func _on_AnimatedSprite_frame_changed():
	if animatedSprite.get_frame() == 5:
		get_tree().call_group("camera", "lightning_strike")
		boltHitBox.disabled = false
