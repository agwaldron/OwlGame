extends KinematicBody2D

enum {
	IDLE,
	LEMON,
	SMOKE,
	ENRAGING,
	ENRAGED_IDLE
}

const Lemon = preload("res://src/Enemies/TheDude/Projectiles/Lemon.tscn")
const SmokeCloud = preload("res://src/Enemies/TheDude/Projectiles/SmokeCloud.tscn")

onready var animatedSprite = $AnimatedSprite
onready var stats = $EnemyStats

var lemonNext
var state
var startenrage

var hitflashduration = 8
var hitflashtimer = 0
var hitflashflag = false

func _ready():
	stats.health = 15
	lemonNext = true
	state = IDLE
	startenrage = false
	animatedSprite.play("Idle")
	animatedSprite.set_frame(0)
	start_attack()

func _process(delta):
	if hitflashflag:
		hit_flash_countdown(delta)

func start_attack():
	if state == IDLE:
		if startenrage:
			enrage()
		elif lemonNext:
			animatedSprite.play("GrabLemon")
			state = LEMON
		else:
			animatedSprite.play("BlowSmoke")
			state = SMOKE
	elif state == ENRAGED_IDLE:
		pass
	animatedSprite.set_frame(0)

func throw_lemon():
	var lemon = Lemon.instance()
	get_parent().add_child(lemon)
	lemon.global_position = global_position
	lemon.global_position.x -= lemon.sprite_horizontal_offset
	lemon.global_position.y -= lemon.sprite_vertical_offset
	lemon.velocity.x = lemon.HORIZONTAL_SPEED

func blow_smoke():
	var smokeCloud = SmokeCloud.instance()
	get_parent().add_child(smokeCloud)
	smokeCloud.global_position = global_position
	smokeCloud.global_position.x -= smokeCloud.sprite_horizontal_offset
	smokeCloud.global_position.y -= smokeCloud.sprite_vertical_offset

func enrage_flag():
	if state == IDLE:
		enrage()
	else:
		startenrage = true

func enrage():
	animatedSprite.play("Enrage")
	animatedSprite.set_frame(0)
	state = ENRAGING
	startenrage = false

func hit_flash_countdown(delta):
	if hitflashtimer <= 0:
		animatedSprite.material.set_shader_param("white", false)
		hitflashflag = false
	else:
		hitflashtimer -= delta * 100

func _on_AnimatedSprite_frame_changed():
	if state == LEMON and animatedSprite.get_frame() == 14:
		call_deferred("throw_lemon")
	elif state == SMOKE and animatedSprite.get_frame() == 13:
		call_deferred("blow_smoke")

func _on_AnimatedSprite_animation_finished():
	if startenrage:
		call_deferred("enrage")
	elif state == LEMON:
		lemonNext = false
		state = IDLE
		animatedSprite.play("Idle")
	elif state == SMOKE:
		lemonNext = true
		state = IDLE
		animatedSprite.play("Idle")
	elif state == ENRAGING:
		animatedSprite.play("EnragedIdle")
		state = ENRAGED_IDLE

func _on_TheDude_area_entered(area):
	var area_groups = area.get_groups()
	for x in area_groups:
		if x == "PlayerSpell":
			hitflashtimer = hitflashduration
			hitflashflag = true
			animatedSprite.material.set_shader_param("white", true)
			stats.health -= area.damage

func _on_EnemyStats_no_health():
	queue_free()
