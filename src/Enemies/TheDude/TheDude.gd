extends KinematicBody2D

const Lemon = preload("res://src/Enemies/TheDude/Projectiles/Lemon.tscn")

onready var animatedSprite = $AnimatedSprite
onready var stats = $EnemyStats

func _ready():
	stats.health = 15
	animatedSprite.play("GrabLemon")
	animatedSprite.set_frame(0)

func throw_lemon():
	var lemon = Lemon.instance()
	get_parent().add_child(lemon)
	lemon.global_position = global_position
	lemon.global_position.x -= lemon.sprite_horizontal_offset
	lemon.global_position.y -= lemon.sprite_vertical_offset
	lemon.velocity.x = lemon.HORIZONTAL_SPEED

func _on_AnimatedSprite_frame_changed():
	if animatedSprite.get_frame() == 14:
		call_deferred("throw_lemon")

func _on_TheDude_area_entered(area):
	var area_groups = area.get_groups()
	for x in area_groups:
		if x == "PlayerSpell":
			stats.health -= area.damage

func _on_EnemyStats_no_health():
	queue_free()
