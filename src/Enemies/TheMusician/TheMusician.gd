extends KinematicBody2D

export var PLAY_FREQ = 150

enum{
	IDLE,
	PLAY
}

const EighthNote = preload("res://src/Enemies/TheMusician/EighthNote.tscn")

onready var stats = $EnemyStats
onready var animatedSprite = $AnimatedSprite

var state = IDLE
var play_cool_down

func _ready():
	stats.health = 30
	play_cool_down = PLAY_FREQ

func _process(delta):
	match state:
		IDLE:
			idle_state(delta)
		PLAY:
			play_state(delta)

func idle_state(delta):
	play_cool_down -= (delta * 100)
	if play_cool_down <= 0:
		play_note()

func play_state(delta):
	play_cool_down = PLAY_FREQ
	state = IDLE

func play_note():
	var eighthNote = EighthNote.instance()
	get_parent().add_child(eighthNote)
	eighthNote.global_position = global_position
	eighthNote.global_position.x -= eighthNote.sprite_horizontal_offset
	eighthNote.global_position.y -= eighthNote.sprite_vertical_offset
	eighthNote.velocity.x = eighthNote.SPEED * -1
	state = PLAY

func _on_HurtBox_area_entered(area):
	stats.health -= area.damage
	print(stats.health)

func _on_EnemyStats_no_health():
	queue_free()
