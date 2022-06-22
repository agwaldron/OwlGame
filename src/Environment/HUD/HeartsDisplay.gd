extends CenterContainer

onready var emptyHeartDisplay = $EmptyHeartDisplay
onready var fullHeartDisplay = $FullHeartDisplay

var maxHealth
var health
var spriteWidth = 64

func _process(_delta):
	fullHeartDisplay.rect_size.x = health * spriteWidth
	emptyHeartDisplay.rect_size.x = maxHealth * spriteWidth

func set_max(val):
	maxHealth = val
	health = maxHealth

func set_health(val):
	health = val
	if health == 0:
		fullHeartDisplay.visible = false
