extends CenterContainer

onready var emptyheartdisplay = $EmptyHeartDisplay
onready var fullheartdisplay = $FullHeartDisplay

var maxhealth
var health
var spritewidth = 64

func _process(_delta):
	fullheartdisplay.rect_size.x = health * spritewidth
	emptyheartdisplay.rect_size.x = maxhealth * spritewidth

func setMax(val):
	maxhealth = val
	health = maxhealth

func setHealth(val):
	health = val
	if health == 0:
		fullheartdisplay.visible = false
