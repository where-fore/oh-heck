extends TextureRect

@export var my_label:RichTextLabel
var typewriter_characters_per_second:float = 12

func _ready() -> void:
	visible = false
	my_label.text = ""
	scroll_text("HAHAHA HAHAHAHAHA")

func scroll_text(new_text:String) -> void:
	if not visible: await tween_bubble_in()
		
	my_label.visible_characters = 0
	my_label.text = new_text
	
	var total_characters:int = my_label.get_total_character_count()
	var duration:float = total_characters / typewriter_characters_per_second
	
	var visible_characters_tween:Tween = create_tween()
	visible_characters_tween.tween_property(my_label, "visible_characters", total_characters, duration)

func tween_bubble_in() -> bool:
	scale = Vector2(0,0)
	visible = true
	var tween:Tween = create_tween()
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2(1,1), 1)
	
	await tween.finished
	return true
