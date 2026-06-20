extends TextureRect
class_name DialoguePopup

@export var my_label:RichTextLabel
var typewriter_characters_per_second:float = 12
var scroll_text_tween:Tween
var fade_out_bubble_tween:Tween

func _ready() -> void:
	my_label.text = ""

func scroll_text(new_text:String) -> void:
	my_label.visible_characters = 0
	my_label.text = new_text
	
	await tween_bubble_in()
	
	var total_characters:int = my_label.get_total_character_count()
	var duration:float = total_characters / typewriter_characters_per_second
	
	scroll_text_tween = create_tween()
	scroll_text_tween.tween_property(my_label, "visible_characters", total_characters, duration)
	
	await scroll_text_tween.finished
	await get_tree().create_timer(1 + total_characters/8.0).timeout
	tween_bubble_out()

func tween_bubble_in() -> bool:
	scale = Vector2(0,0)
	visible = true
	modulate = Color(1,1,1,1)
	var tween:Tween = create_tween()
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2(1,1), 1)
	
	await tween.finished
	return true

func tween_bubble_out() -> void:
	var my_color:Color = modulate
	fade_out_bubble_tween = create_tween()
	fade_out_bubble_tween.set_ease(Tween.EASE_IN)
	fade_out_bubble_tween.set_trans(Tween.TRANS_QUAD)
	fade_out_bubble_tween.tween_property(self, "modulate", Color(my_color.r, my_color.g, my_color.b, 0), 1.5)
	
	await fade_out_bubble_tween.finished
	queue_free()
