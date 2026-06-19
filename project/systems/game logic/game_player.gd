extends Node
class_name GamePlayer

@export var hand:Hand
@export var playmat:Playmat

var controlled_by_ai:bool = false

var have_played_this_round:bool = false

signal tricks_updated
var current_tricks:int = 0:
	set(value):
		current_tricks = value
		tricks_updated.emit()

signal bid_updated
var current_bid:int = 0:
	set(value):
		current_bid = value
		bid_updated.emit()

signal points_updated
var overall_points:int = 0:
	set(value):
		overall_points = value
		points_updated.emit()


func _ready() -> void:
	@warning_ignore("untyped_declaration") #programmer short hand for yeeting all the arguments
	playmat.card_added.connect(func(_unused_data) -> void: playmat.recalculate_total())
	@warning_ignore("untyped_declaration") #programmer short hand for yeeting all the arguments
	playmat.card_removed.connect(func(_unused_data) -> void: playmat.recalculate_total())

func start_turn() -> void:
	if controlled_by_ai: UiEvents.card_selected_to_play.emit(self, ai_choose_card())

func play_card(card_to_play:Card) -> void:
	playmat.add_card(card_to_play)
	hand.remove_card(card_to_play)
	have_played_this_round = true

func award_trick() -> void:
	current_tricks += 1

func complete_hand() -> void:
	hand.discard_hand()
	award_points_from_hand()
	reset_per_hand()

func award_points_from_hand() -> void:
	var points_this_round:int = 0
	points_this_round += Rules.points_per_trick * current_tricks
	
	if current_bid == current_tricks:
		points_this_round += Rules.points_per_bid_success
	
	overall_points += points_this_round

func reset_per_hand() -> void:
	current_bid = 0
	current_tricks = 0

func ai_choose_card() -> Card:
	var available_cards:Array[Card]
	for card:Card in hand.cards_in_hand:
		if card.available_to_play: available_cards.append(card)
	return available_cards.pick_random()

func ai_choose_bid(current_sum:int, maximum_hand_size:int) -> void:
	var found_a_bid:bool = false
	var found_bid:int
	while found_a_bid == false:
		found_bid = randi_range(0, hand.cards_in_hand.size())
		found_a_bid = Rules.validate_bid(found_bid, current_sum, maximum_hand_size)
	current_bid = found_bid
	UiEvents.bid_added.emit(current_bid)
