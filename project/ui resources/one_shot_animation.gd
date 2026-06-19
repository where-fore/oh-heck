extends Sprite2D
class_name OneShotAnimation

@export var destination_x:int
@export var destination_y:int
@export var destination_size_x:int
@export var destination_size_y:int

func _ready() -> void:
	visible = false
	play_animation()

func play_animation() -> void:
	visible = true
	var tween:Tween = create_tween()
	
	tween.tween_property(self, "scale", Vector2(15,15), 0.25)
	tween.tween_property(self, "scale", Vector2(9,9), 0.45)
	tween.pause()
	
	await tween.finished
	queue_free()
