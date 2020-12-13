extends KinematicBody2D

enum {
	SUMMON,
	POUR,
	VANISH
}

const WineWave = preload("res://src/Enemies/TheWitch/Spells/WineWave.tscn")

onready var animatedSprite = $AnimatedSprite
onready var hitboxsmall = $HitBoxSmall/CollisionShape2D
onready var hitboxfull = $HitBox2Full/CollisionShape2D

var state
var horoffset = 100
var vertoffset = 0

func _ready():
	animatedSprite.play("Summon")
	animatedSprite.set_frame(0)
	state = SUMMON
	hitboxsmall.disabled = false

func summonWave():
	var wineWave = WineWave.instance()
	get_parent().add_child(wineWave)
	wineWave.global_position = global_position
	wineWave.global_position.y += wineWave.vertoffset
	wineWave.z_index = z_index

func vanish():
	state = VANISH
	animatedSprite.play("Vanish")
	animatedSprite.set_frame(0)

func _on_AnimatedSprite_frame_changed():
	if state == SUMMON and animatedSprite.get_frame() == 3:
		hitboxsmall.disabled = true
		hitboxfull.disabled = false

func _on_AnimatedSprite_animation_finished():
	if state == SUMMON:
		state = POUR
		animatedSprite.play("Pour")
	elif state == POUR:
		summonWave()
		#get_tree().call_group("TheWitch", "wineFinished")
	elif state == VANISH:
		queue_free()
