extends KinematicBody2D

enum {
	IDLE,
	LEMON,
	SMOKE
}

const Lemon = preload("res://src/Enemies/TheDude/Projectiles/Lemon.tscn")
const SmokeCloud = preload("res://src/Enemies/TheDude/Projectiles/SmokeCloud.tscn")

onready var animatedSprite = $AnimatedSprite
onready var stats = $EnemyStats

var lemonNext
var state

func _ready():
	stats.health = 15
	lemonNext = true
	state = IDLE
	animatedSprite.play("Idle")
	animatedSprite.set_frame(0)
	start_attack()

func start_attack():
	if lemonNext:
		animatedSprite.play("GrabLemon")
		state = LEMON
	else:
		animatedSprite.play("BlowSmoke")
		state = SMOKE
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

func _on_AnimatedSprite_frame_changed():
	if state == LEMON and animatedSprite.get_frame() == 14:
		call_deferred("throw_lemon")
	elif state == SMOKE and animatedSprite.get_frame() == 13:
		call_deferred("blow_smoke")

func _on_AnimatedSprite_animation_finished():
	if state == LEMON:
		lemonNext = false
		state = IDLE
		animatedSprite.play("Idle")
	elif state == SMOKE:
		lemonNext = true
		state = IDLE
		animatedSprite.play("Idle")

func _on_TheDude_area_entered(area):
	var area_groups = area.get_groups()
	for x in area_groups:
		if x == "PlayerSpell":
			stats.health -= area.damage

func _on_EnemyStats_no_health():
	queue_free()
