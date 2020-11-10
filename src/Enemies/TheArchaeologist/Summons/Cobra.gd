extends KinematicBody2D

enum {
	SUMMON,
	MOVING,
	VANISH
}

onready var animatedSprite = $AnimatedSprite
onready var movingNeckHitBox = $MovingNeckHitBox/CollisionShape2D
onready var movingBodyHitBox = $MovingBodyHitBox/CollisionShape2D
onready var summonSmallHitBox = $SummonSmallHitBox/CollisionShape2D
onready var summonLargeHitBox = $SummonLargeHitBox/CollisionShape2D

var state
var velocity = Vector2.ZERO
var speed = 300
var horizontaloffset = 100

func _ready():
	animatedSprite.play("Summon")
	animatedSprite.set_frame(0)
	summonSmallHitBox.disabled = false
	state = SUMMON

func _process(_delta):
	if state == MOVING:
		velocity = move_and_slide(velocity)

func startMoving():
	animatedSprite.play("Move")
	animatedSprite.set_frame(0)
	state = MOVING
	velocity.x = speed * -1
	summonLargeHitBox.disabled = true
	movingNeckHitBox.disabled = false
	movingBodyHitBox.disabled = false

func vanish():
	velocity = Vector2.ZERO
	global_position.x += 20
	state = VANISH
	animatedSprite.play("Vanish")
	animatedSprite.set_frame(0)

func _on_AnimatedSprite_frame_changed():
	if state == SUMMON and animatedSprite.get_frame() == 6:
		summonSmallHitBox.disabled = true
		summonLargeHitBox.disabled = false

func _on_AnimatedSprite_animation_finished():
	if state == SUMMON:
		call_deferred("startMoving")
	elif state == VANISH:
		get_tree().call_group("archaeologist", "summon_complete")
		queue_free()

func _on_MovingNeckHitBox_body_entered(_body):
	call_deferred("vanish")
