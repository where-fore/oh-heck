extends Node2D
class_name Hand

signal card_added(new_card:Card)
signal card_removed(old_card:Card)
var cards_in_hand:Array[Card]

func add_card(card_to_add:Card) -> void:
	_add_card(card_to_add)

func add_cards(new_cards:Array[Card]) -> void:
	for card:Card in new_cards:
		_add_card(card)

func discard_card(card_to_discard:Card) -> void:
	_discard_card(card_to_discard)

func remove_card(card_to_discard:Card) -> void:
	_remove_card(card_to_discard)

func discard_hand() -> void:
	for card:Card in cards_in_hand.duplicate():
		_discard_card(card)

func _add_card(new_card:Card) -> void:
	cards_in_hand.append(new_card)
	card_added.emit(new_card)

func _discard_card(card_to_discard:Card) -> void:
	UiEvents.card_sent_to_discard.emit(card_to_discard)
	_remove_card(card_to_discard)

func _remove_card(card_to_remove:Card) -> void:
	cards_in_hand.erase(card_to_remove)
	card_removed.emit(card_to_remove)
