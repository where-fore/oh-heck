extends Node
class_name GamePlayer

@export var hand:Hand
@export var playmat:Playmat

var controlled_by_ai:bool = false
var hand_hidden:bool = false

var have_played_this_round:bool = false

signal tricks_updated
var current_tricks:int = 0:
	set(value):
		current_tricks = value
		tricks_updated.emit()

signal bid_updated
var current_bid:int = -1:
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
	UiEvents.turn_started.emit(self)
	
	if controlled_by_ai:
		await get_tree().create_timer(randfn(1,0.25)).timeout
		UiEvents.card_selected_to_play.emit(self, ai_choose_card())

func play_card(card_to_play:Card) -> void:
	playmat.add_card(card_to_play)
	card_to_play.available_to_play = true
	
	hand.remove_card(card_to_play)
	have_played_this_round = true
	
	UiEvents.turn_ended.emit(self)

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
	current_bid = -1
	current_tricks = 0

func ai_choose_card() -> Card:
	var available_cards:Array[Card]
	for card:Card in hand.cards_in_hand:
		if card.available_to_play: available_cards.append(card)
	
	#print_debug("decided what card to play...")
	#var to_print:Array[String]
	#for card in hand.cards_in_hand:
		#to_print.append(card.print_string)
	#print("hand: ", ", ".join(to_print))
	#to_print = []
	#for card in available_cards:
		#to_print.append(card.print_string)
	#print("available: ", ", ".join(to_print))
	
	if Tutorial.tutorial_hand_stage == 2:
		var card_to_return:Card
		for card:Card in available_cards:
			if card.suit == Names.suit_sun:
				card_to_return = card
		if card_to_return: return card_to_return
		else: return available_cards.pick_random()
	
	if Tutorial.tutorial_hand_stage == 3:
		var card_to_return:Card
		for card:Card in available_cards:
			if card.value == 3:
				card_to_return = card
		if card_to_return: return card_to_return
		else: return available_cards.pick_random()
	
	var best_card:Card
	var best_value:int = 0
	if current_tricks < current_bid:
		#try to take
		#play highest trump, or highest on suit (or highest if no suit declared yet ie. going first), or lowest off suit
		for card:Card in available_cards:
			if card.suit == Rules.current_prime:
				if card.value > best_value:
					best_value = card.value
					best_card = card
		if not best_card:
			best_value = 0
			for card:Card in available_cards:
				if card.suit == Rules.current_lead_suit or Rules.current_lead_suit == Rules.unset_suit:
					if card.value > best_value:
						best_value = card.value
						best_card = card
		if not best_card:
			best_value = 0
			for card:Card in available_cards:
				if card.value < best_value or best_value == 0:
					best_value = card.value
					best_card = card
	elif current_tricks >= current_bid :
		#try not to take
		#play highest off suit, lowest on suit, highest trump
		for card:Card in available_cards:
			if card.suit != Rules.current_lead_suit and card.suit != Rules.current_prime:
				if card.value > best_value:
					best_value = card.value
					best_card = card
			
		if not best_card:
			best_value = 0
			for card:Card in available_cards:
				if card.suit == Rules.current_lead_suit:
					if card.value < best_value or best_value == 0:
						best_value = card.value
						best_card = card
			
		if not best_card:
			best_value = 0
			for card:Card in available_cards:
				if card.suit == Rules.current_prime:
					if card.value > best_value:
						best_value = card.value
						best_card = card
	
	if not best_card: best_card = available_cards.pick_random()
	
	return best_card

func ai_choose_bid(current_sum:int, maximum_hand_size:int) -> void:
	#print_debug("decided what bid to make...")
	#var to_print:Array[String]
	#for card in hand.cards_in_hand:
		#to_print.append(card.print_string)
	#print("hand: ", ", ".join(to_print))
	
	var estimated_tricks:int = 0
	for card in hand.cards_in_hand:
		if card.suit == Rules.current_prime:
			@warning_ignore("integer_division")
			if card.value >= Rules.max_card_value_to_create * 1 / 3:
				estimated_tricks += 1
				#print(card.print_string, " very good")
		else:
			@warning_ignore("integer_division")
			if card.value >= Rules.max_card_value_to_create * 2 / 3:
				estimated_tricks += 1
				#print(card.print_string, " very good")
	
	while not Rules.validate_bid(estimated_tricks, current_sum, maximum_hand_size):
		estimated_tricks += 1
	
	current_bid = estimated_tricks
	UiEvents.bid_added.emit(estimated_tricks)
