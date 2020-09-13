extends KinematicBody2D

const PaintBall = preload("res://src/Enemies/ThePainter/Paints/PaintBall.tscn")

onready var animatedSprite = $AnimatedSprite

var velocity = Vector2.ZERO
var isRed

var redMaxHeight = -200
var redRowOne = [
	[200, -100],
	[600, -100],
	[1000, -100],
	[1400, -100]
]
var redRowTwo = [
	[400, -300],
	[800, -300],
	[1200, -300],
	[1600, -300]
]
var redRowThree = [
	[300, -500],
	[700, -500],
	[1100, -500],
	[1500, -500]
]
var redRowFour = [
	[500, -700],
	[900, -700],
	[1300, -700],
	[1700, -700]
]
var redRowFive = [
	[200, -900],
	[600, -900],
	[1000, -900],
	[1400, -900]
]

var horizontalCenter
var yellow_rad_offset = 25
var yellow_speed = 800
var yellowBlobs = [
	[0, -1, 0, -1],
	[sqrt(2.0)/2.0, -sqrt(2.0)/2.0, sqrt(2.0)/2.0, -sqrt(2.0)/2.0],
	[1, 0, 1, 0],
	[sqrt(2.0)/2.0, sqrt(2.0)/2.0, sqrt(2.0)/2.0, sqrt(2.0)/2.0],
	[0, 1, 0, 1],
	[-sqrt(2.0)/2.0, sqrt(2.0)/2.0, -sqrt(2.0)/2.0, sqrt(2.0)/2.0],
	[-1, 0, -1, 0],
	[-sqrt(2.0)/2.0, -sqrt(2.0)/2.0, -sqrt(2.0)/2.0, -sqrt(2.0)/2.0]
]

func _ready():
	horizontalCenter = get_viewport().size.x / 2

func _process(delta):
	velocity = move_and_slide(velocity)
	if isRed:
		if global_position.y <= redMaxHeight:
			create_red_blobs()
	else:
		if global_position.x <= horizontalCenter:
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
	var paintBall
	for pb in yellowBlobs:
		paintBall = PaintBall.instance()
		get_parent().add_child(paintBall)
		paintBall.global_position.x = global_position.x + (pb[0] * yellow_rad_offset)
		paintBall.global_position.y = global_position.y + (pb[1] * yellow_rad_offset)
		paintBall.set_color("yellow")
		paintBall.velocity = Vector2(pb[2]*yellow_speed, pb[3]*yellow_speed)
	
	queue_free()

func set_color(col):
	match col:
		"red":
			isRed = true
			animatedSprite.play("Red")
		"yellow":
			isRed = false
			animatedSprite.play("Yellow")
