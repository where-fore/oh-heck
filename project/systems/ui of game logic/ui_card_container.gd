extends HBoxContainer
class_name UICardContainer

func clear_cards() -> void:
	for child:Node in get_children():
		child.queue_free()
