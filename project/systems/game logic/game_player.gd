extends Node
class_name GamePlayer

@export var hand:Hand
@export var playmat:Playmat
var current_tricks:int = 0
var current_bid:int
var overall_points:int = 0
var have_played_this_round:bool = false

func _ready() -> void:
	@warning_ignore("untyped_declaration") #programmer short hand for yeeting all the arguments
	playmat.card_added.connect(func(_unused_data) -> void: playmat.recalculate_total())
	@warning_ignore("untyped_declaration") #programmer short hand for yeeting all the arguments
	playmat.card_removed.connect(func(_unused_data) -> void: playmat.recalculate_total())

func play_card(card_to_play:Card) -> void:
	playmat.add_card(card_to_play)
	hand.remove_card(card_to_play)
	have_played_this_round = true

func award_trick() -> void:
	current_tricks += 1
