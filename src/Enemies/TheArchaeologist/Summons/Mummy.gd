extends KinematicBody2D

export var SHUFFLE_SPEED = 200

onready var animatedSprite = $AnimatedSprite
onready var hurtBox = $HurtBox/CollisionShape2D
onready var stats = $EnemyStats

var velocity = Vector2.ZERO
var movingLeft
var turning
var crumbling
var turnAroundLeft = 200
var turnAroundRight = 1000
#var hitflashduration = 10
#var hitflashtimer = 0
#var hitflashflag

func _ready():
	stats.health = 2
	movingLeft = true
	turning = false
	crumbling = false
	velocity.x = -SHUFFLE_SPEED
	animatedSprite.play("ShuffleLeft")

func _process(_delta):
	#if hitflashflag:
		#hit_flash_countdown(delta)
	if global_position.x < turnAroundLeft or global_position.x > turnAroundRight:
		turn_around()
	velocity = move_and_slide(velocity)

func turn_around():
	turning = true
	if movingLeft:
		animatedSprite.play("TurnLeft")
		animatedSprite.set_frame(0)
		global_position.x = turnAroundLeft + 5
	else:
		animatedSprite.play("TurnRight")
		animatedSprite.set_frame(0)
		global_position.x = turnAroundRight - 5

#func hit_flash_countdown(delta):
	#if hitflashtimer <= 0:
		#hitflashflag = false
		#animatedSprite.material.set_shader_param("white", false)
	#else:
		#hitflashtimer -= delta * 100

func crumble():
	velocity.x = 0
	hurtBox.disabled = true
	if movingLeft:
		animatedSprite.play("CrumbleLeft")
	else:
		animatedSprite.play("CrumbleRight")
	animatedSprite.set_frame(0)
	crumbling = true

func _on_HurtBox_area_entered(area):
	#hitflashtimer = hitflashduration
	#hitflashflag = true
	#animatedSprite.material.set_shader_param("white", true)
	var areaGroups = area.get_groups()
	for x in areaGroups:
		if x == "PlayerSpell":
			stats.health -= area.damage

func _on_EnemyStats_no_health():
	call_deferred("crumble")

func _on_AnimatedSprite_frame_changed():
	if not crumbling:
		if animatedSprite.get_frame() == 0:
			velocity.x = 0
		elif animatedSprite.get_frame() == 4:
			if movingLeft:
				velocity.x = -SHUFFLE_SPEED
			else:
				velocity.x = SHUFFLE_SPEED

func _on_AnimatedSprite_animation_finished():
	if turning:
		turning = false
		if movingLeft:
			animatedSprite.play("ShuffleRight")
			animatedSprite.set_frame(0)
			movingLeft = false
		else:
			animatedSprite.play("ShuffleLeft")
			animatedSprite.set_frame(0)
			movingLeft = true
	elif crumbling:
		queue_free()
