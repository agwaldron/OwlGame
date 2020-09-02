extends KinematicBody2D

export var CAST_FREQ = 150
export var CAST_DURATION = 100

enum{
	IDLE,
	CAST
}

const WitchFire = preload("res://src/Enemies/Witch/WitchFire.tscn")

onready var stats = $EnemyStats
onready var animatedSprite = $AnimatedSprite

var state = IDLE
var cast_timer
var cast_cool_down

func _ready():
	stats.health = 2
	cast_cool_down = CAST_FREQ

func _process(delta):
	match state:
		IDLE:
			idle_state(delta)
		CAST:
			cast_state(delta)

func idle_state(delta):
	cast_cool_down -= (delta * 100)
	if cast_cool_down <= 0:
		cast_witch_fire()

func cast_state(delta):
	cast_timer -= (delta * 100)
	if cast_timer <= 0:
		animatedSprite.play("Idle")
		cast_cool_down = CAST_FREQ
		state = IDLE

func cast_witch_fire():
	animatedSprite.play("Cast")
	var witchFire = WitchFire.instance()
	get_parent().add_child(witchFire)
	witchFire.global_position = global_position
	witchFire.global_position.y -= witchFire.sprite_vertical_offset
	witchFire.global_position.x -= witchFire.sprite_horizontal_offset
	witchFire.velocity.x = witchFire.SPEED * -1
	witchFire.animatedSprite.play("Left")
	cast_timer = CAST_DURATION
	state = CAST

func _on_HurtBox_area_entered(area):
	stats.health -= area.damage

func _on_EnemyStats_no_health():
	queue_free()
