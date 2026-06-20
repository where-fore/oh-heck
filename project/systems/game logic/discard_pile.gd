extends Hand
class_name DiscardPile


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	UiEvents.card_sent_to_discard.connect(add_card)

func return_discard_pile() -> Array[Card]:
	var to_return:Array[Card]
	if to_return == null:
		print_debug("test")
	to_return.assign(cards_in_hand)
	
	for card:Card in cards_in_hand.duplicate():
		_remove_card(card)
	
	return to_return
