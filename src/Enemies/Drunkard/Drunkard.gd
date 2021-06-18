extends KinematicBody2D

enum{
	LEFTNOBEER,
	LEFTBEER,
	RIGHTNOBEER,
	RIGHTBEER
}

onready var animatedSprite = $AnimatedSprite
onready var leftColBox = $LeftCollisionShape2D
onready var leftHurtBox = $LeftHurtBox/CollisionShape2D
onready var rightColBox = $RightCollisionShape2D
onready var rightHurtBox = $RightHurtBox/CollisionShape2D
onready var stats = $EnemyStats

var state
var speed = 275
var velocity = Vector2.ZERO
var movingleft

var hitflashduration = 8
var hitflashtimer
var hitflashflag

func _ready():
	state = LEFTBEER
	animatedSprite.play("MoveLeftBeer")
	movingleft = true
	leftColBox.disabled = false
	leftHurtBox.disabled = false
	velocity = Vector2(speed * -1, 0)
	stats.health = 3
	hitflashflag = false
	hitflashtimer = 0

func _process(delta):
	if hitflashflag:
		hit_flash_cooldown(delta)
	if is_on_wall():
		turn_around()
	velocity = move_and_slide(velocity)

func turn_around():
	movingleft = not movingleft
	leftColBox.disabled = not leftColBox.disabled
	leftHurtBox.disabled = not leftHurtBox.disabled
	rightColBox.disabled = not rightColBox.disabled
	rightHurtBox.disabled = not rightHurtBox.disabled
	if movingleft:
		animatedSprite.play("MoveLeftBeer")
		velocity = Vector2(speed * -1, 0)
	else:
		animatedSprite.play("MoveRightBeer")
		velocity = Vector2(speed, 0)

func hit_flash_cooldown(delta):
	if hitflashtimer <= 0:
		hitflashflag = false
		animatedSprite.material.set_shader_param("white", false)
	else:
		hitflashtimer -= (delta * 100)

func _on_HurtBox_area_entered(area):
	var areagroups = area.get_groups()
	for x in areagroups:
		if x == "PlayerSpell":
			hitflashtimer = hitflashduration
			hitflashflag = true
			animatedSprite.material.set_shader_param("white", true)
			stats.health -= area.damage

func _on_EnemyStats_no_health():
	queue_free()
