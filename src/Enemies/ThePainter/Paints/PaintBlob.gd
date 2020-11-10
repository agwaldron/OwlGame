extends KinematicBody2D

const PaintBall = preload("res://src/Enemies/ThePainter/Paints/PaintBall.tscn")

onready var animatedSprite = $AnimatedSprite
onready var hitBox = $HitBox/CollisionShape2D

var velocity = Vector2.ZERO
var isRed
var splat = false

var redMaxHeight = -200
var redRowOne = [
	[100, -100],
	[350, -100],
	[600, -100],
	[850, -100]
]
var redRowTwo = [
	[150, -300],
	[400, -300],
	[650, -300],
	[900, -300]
]
var redRowThree = [
	[200, -500],
	[450, -500],
	[700, -500],
	[950, -500]
]
var redRowFour = [
	[250, -700],
	[500, -700],
	[750, -700],
	[1000, -700]
]
var redRowFive = [
	[300, -900],
	[550, -900],
	[800, -900],
	[1050, -900]
]

var horizontalCenter
var yellow_rad_offset = 25
var yellow_outer_speed = 800
var yellow_inner_speed = 400
var yellowBlobsOuter = [
	[0.0, -1.0],
	[sqrt(2.0)/2.0, -sqrt(2.0)/2.0],
	[1.0, 0.0],
	[sqrt(2.0)/2.0, sqrt(2.0)/2.0],
	[0.0, 1.0],
	[-sqrt(2.0)/2.0, sqrt(2.0)/2.0],
	[-1.0, 0.0],
	[-sqrt(2.0)/2.0, -sqrt(2.0)/2.0]
]
var yellowBlobsInner = [
	[0.5, -sqrt(3.0)/2.0],
	[sqrt(3.0)/2.0, -0.5],
	[0.5, sqrt(3.0)/2.0],
	[sqrt(3.0)/2.0, 0.5],
	[-0.5, sqrt(3.0)/2.0],
	[-sqrt(3.0)/2.0, 0.5],
	[-0.5, -sqrt(3.0)/2.0],
	[-sqrt(3.0)/2.0, -0.5]
]

func _ready():
	horizontalCenter = get_viewport().size.x / 2

func _process(_delta):
	velocity = move_and_slide(velocity)
	if isRed:
		if global_position.y <= redMaxHeight:
			create_red_blobs()
	else:
		if global_position.x <= horizontalCenter and not splat:
			create_yellow_blobs()

func create_red_blobs():
	var paintBall
	for pb in redRowOne:
		paintBall = PaintBall.instance()
		get_parent().add_child(paintBall)
		paintBall.global_position.x = pb[0]
		paintBall.global_position.y = pb[1]
		paintBall.set_color("red")
		paintBall.velocity = Vector2(0, paintBall.maxFallSpeed)

	for pb in redRowTwo:
		paintBall = PaintBall.instance()
		get_parent().add_child(paintBall)
		paintBall.global_position.x = pb[0]
		paintBall.global_position.y = pb[1]
		paintBall.set_color("red")
		paintBall.velocity = Vector2(0, paintBall.maxFallSpeed)

	for pb in redRowThree:
		paintBall = PaintBall.instance()
		get_parent().add_child(paintBall)
		paintBall.global_position.x = pb[0]
		paintBall.global_position.y = pb[1]
		paintBall.set_color("red")
		paintBall.velocity = Vector2(0, paintBall.maxFallSpeed)

	for pb in redRowFour:
		paintBall = PaintBall.instance()
		get_parent().add_child(paintBall)
		paintBall.global_position.x = pb[0]
		paintBall.global_position.y = pb[1]
		paintBall.set_color("red")
		paintBall.velocity = Vector2(0, paintBall.maxFallSpeed)

	for pb in redRowFive:
		paintBall = PaintBall.instance()
		get_parent().add_child(paintBall)
		paintBall.global_position.x = pb[0]
		paintBall.global_position.y = pb[1]
		paintBall.set_color("red")
		paintBall.velocity = Vector2(0, paintBall.maxFallSpeed)

	queue_free()

func create_yellow_blobs():
	hitBox.disabled = true
	animatedSprite.play("YellowSplatter")
	splat = true
	velocity = Vector2.ZERO

	var paintBall
	for pb in yellowBlobsOuter:
		paintBall = PaintBall.instance()
		get_parent().add_child(paintBall)
		paintBall.global_position.x = global_position.x + (pb[0] * yellow_rad_offset)
		paintBall.global_position.y = global_position.y + (pb[1] * yellow_rad_offset)
		paintBall.set_color("yellow")
		paintBall.velocity = Vector2(pb[0]*yellow_outer_speed, pb[1]*yellow_outer_speed)

	for pb in yellowBlobsInner:
		paintBall = PaintBall.instance()
		get_parent().add_child(paintBall)
		paintBall.global_position.x = global_position.x + (pb[0] * yellow_rad_offset)
		paintBall.global_position.y = global_position.y + (pb[1] * yellow_rad_offset)
		paintBall.set_color("yellow")
		paintBall.velocity = Vector2(pb[0]*yellow_inner_speed, pb[1]*yellow_inner_speed)

func set_color(col):
	match col:
		"red":
			isRed = true
			animatedSprite.play("RedFlying")
		"yellow":
			isRed = false
			animatedSprite.play("YellowFlying")

func _on_AnimatedSprite_animation_finished():
	if splat:
		queue_free()
