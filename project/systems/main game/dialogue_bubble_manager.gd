extends Control

@export var individual_bubble:PackedScene

func _ready() -> void:
	Dialogue.new_dialogue_bark.connect(new_dialogue_bubble)
	
	new_dialogue_bubble("HAHAHA WELCOME TO HECK HAHAHAHA")
	await get_tree().create_timer(5).timeout
	new_dialogue_bubble("HAVE SOME CARDS HAHAHAHAH")
	await get_tree().create_timer(3).timeout
	Tutorial.game_start.emit()

func new_dialogue_bubble(new_text:String) -> void:
	var new_bubble:DialoguePopup = individual_bubble.instantiate()
	add_child(new_bubble)
	new_bubble.scroll_text(new_text)
