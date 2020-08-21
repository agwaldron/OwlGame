extends KinematicBody2D

export var CAST_FREQ = 150
export var CAST_DURATION = 100

enum{
	IDLE,
	CAST
}

const FireBall = preload("res://src/Player/Spells/FireBall.tscn")

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
		cast_fire_ball()

func cast_state(delta):
	cast_timer -= (delta * 100)
	if cast_timer <= 0:
		animatedSprite.play("Idle")
		cast_cool_down = CAST_FREQ
		state = IDLE

func cast_fire_ball():
	animatedSprite.play("Cast")
	var fireBall = FireBall.instance()
	get_parent().add_child(fireBall)
	fireBall.global_position = global_position
	fireBall.global_position.y -= 50
	fireBall.global_position.x -= 40
	fireBall.velocity.x = fireBall.SPEED * -1
	fireBall.sprite.set_flip_h(true)
	cast_timer = CAST_DURATION
	state = CAST

func _on_HurtBox_area_entered(area):
	stats.health -= area.damage

func _on_EnemyStats_no_health():
	queue_free()
