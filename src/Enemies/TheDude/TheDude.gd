extends KinematicBody2D

enum {
	IDLE,
	LEMON,
	SMOKE
}

const Lemon = preload("res://src/Enemies/TheDude/Projectiles/Lemon.tscn")

onready var animatedSprite = $AnimatedSprite
onready var stats = $EnemyStats

var lemonNext
var abilityCoolDown = 150
var abilityTimer
var state

func _ready():
	stats.health = 15
	lemonNext = true
	abilityTimer = abilityCoolDown
	state = IDLE
	animatedSprite.play("Idle")
	animatedSprite.set_frame(0)

func _process(delta):
	if state == IDLE:
		abilityTimer -= (delta * 100)
		if abilityTimer <= 0:
			start_attack()

func start_attack():
	if lemonNext:
		animatedSprite.play("GrabLemon")
		state = LEMON
	else:
		animatedSprite.play("BlowSmoke")
		state = SMOKE
	animatedSprite.set_frame(0)

func blow_smoke():
	pass

func throw_lemon():
	var lemon = Lemon.instance()
	get_parent().add_child(lemon)
	lemon.global_position = global_position
	lemon.global_position.x -= lemon.sprite_horizontal_offset
	lemon.global_position.y -= lemon.sprite_vertical_offset
	lemon.velocity.x = lemon.HORIZONTAL_SPEED

func _on_AnimatedSprite_frame_changed():
	if state == LEMON and animatedSprite.get_frame() == 14:
		call_deferred("throw_lemon")
	elif state == SMOKE and animatedSprite.get_frame() == 12:
		call_deferred("blow_smoke")

func _on_AnimatedSprite_animation_finished():
	if state == LEMON:
		lemonNext = false
		abilityTimer = abilityCoolDown
		state = IDLE
		animatedSprite.play("Idle")
	elif state == SMOKE:
		lemonNext = true
		abilityTimer = abilityCoolDown
		state = IDLE
		animatedSprite.play("Idle")

func _on_TheDude_area_entered(area):
	var area_groups = area.get_groups()
	for x in area_groups:
		if x == "PlayerSpell":
			stats.health -= area.damage

func _on_EnemyStats_no_health():
	queue_free()
