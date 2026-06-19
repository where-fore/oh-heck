extends Node2D
class_name Hand

var cards_in_hand:Array[Card]

func add_card(new_card:Card) -> void:
	cards_in_hand.append(new_card)

func add_cards(new_cards:Array[Card]) -> void:
	for card:Card in new_cards:
		add_card(card)

func discard_hand() -> Array[Card]:
	var to_return:Array[Card]
	to_return.assign(cards_in_hand)
	cards_in_hand.clear()
	return to_return
