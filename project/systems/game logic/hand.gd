extends Node2D
class_name Hand

signal card_added(new_card:Card)
signal card_removed(old_card:Card)
var cards_in_hand:Array[Card]

func add_card(new_card:Card) -> void:
	cards_in_hand.append(new_card)
	card_added.emit(new_card)

func remove_card(old_card:Card) -> void:
	cards_in_hand.erase(old_card)
	card_removed.emit(old_card)

func add_cards(new_cards:Array[Card]) -> void:
	for card:Card in new_cards:
		add_card(card)

func discard_hand() -> Array[Card]:	
	var to_return:Array[Card]
	to_return.assign(cards_in_hand)
	
	for card:Card in cards_in_hand.duplicate():
		remove_card(card)
	
	return to_return
