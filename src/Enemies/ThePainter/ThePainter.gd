extends KinematicBody2D

export var CHANGE_DURATION = 200

enum {
	BLUE,
	RED,
	YELLOW
}

onready var animatedSprite = $AnimatedSprite
onready var stats = $EnemyStats

var state = RED
var changeTimer

func _ready():
	stats.health = 15
	changeTimer = CHANGE_DURATION

func _process(delta):
	changeTimer -= (delta * 100)
	if changeTimer <= 0:
		change_color()
		changeTimer = CHANGE_DURATION

func change_color():
	match state:
		BLUE:
			animatedSprite.play("ChangeRed")
			state = RED
		RED:
			animatedSprite.play("ChangeYellow")
			state = YELLOW
		YELLOW:
			animatedSprite.play("ChangeBlue")
			state = BLUE

func play_idle_animation():
	match state:
		BLUE:
			animatedSprite.play("IdleBlue")
		RED:
			animatedSprite.play("IdleRed")
		YELLOW:
			animatedSprite.play("IdleYellow")

func _on_HurtBox_area_entered(area):
	var areaGroups = area.get_groups()
	for x in areaGroups:
		if x == "PlayerSpell":
			stats.health -= area.damage

func _on_EnemyStats_no_health():
	queue_free()


func _on_AnimatedSprite_animation_finished():
	play_idle_animation()
