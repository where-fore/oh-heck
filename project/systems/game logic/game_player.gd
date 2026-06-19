extends Node
class_name GamePlayer

@export var hand:Hand
@export var playmat:Hand
var current_tricks:int = 0
var current_bid:int
var overall_points:int = 0

func play_card(card_to_play:Card) -> void:
	playmat.add_card(card_to_play)
	hand.remove_card(card_to_play)
