extends KinematicBody2D

onready var animatedSprite = $AnimatedSprite
onready var hurtBox = $HurtBox/CollisionShape2D
onready var stats = $EnemyStats

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
