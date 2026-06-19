extends Node2D

@export var deck:Deck
@export var player:GamePlayer
@export var enemy:GamePlayer
@onready var all_gameplayers:Array[GamePlayer] = [player, enemy]
@export var discard_pile:DiscardPile
var current_turn:GamePlayer
var next_leader_index:int = 0
var current_hand_size:int = 3
var current_suit:StringName = unset_suit
const unset_suit:StringName = &"SUIT NOT SET"

func _ready() -> void:
	deck.setup()
	UiEvents.send_game_player_to_top_ui.emit(enemy)
	UiEvents.send_game_player_to_bottom_ui.emit(player)
	UiEvents.card_selected_to_play.connect(check_and_play_card)
	UiEvents.bid_set_to.connect(set_player_bid_to)
	
	current_turn = player
	
	enemy.controlled_by_ai = true
	
	start_hand()

func set_player_bid_to(bid:int) -> void:
	player.current_bid = bid

func start_hand() -> void:
	deck.shuffle_deck(discard_pile.return_discard_pile())
	
	var cards_dealt_to_all:int = 0
	while cards_dealt_to_all < current_hand_size:
		for gameplayer:GamePlayer in all_gameplayers:
			gameplayer.hand.add_card(deck.draw_top_card())
		cards_dealt_to_all += 1
	
	UiEvents.set_prime_card.emit(deck.draw_top_card())
	
	UiEvents.begin_bidding.emit()
	await UiEvents.end_bidding
	
	current_turn = all_gameplayers[next_leader_index]
	next_leader_index += 1
	if next_leader_index > all_gameplayers.size() - 1: next_leader_index = 0
	
	current_turn.start_turn()

func check_and_play_card(gameplayer:GamePlayer, card:Card) -> void:
	if gameplayer == current_turn:
		gameplayer.play_card(card)
		if current_suit == unset_suit:
			current_suit = card.suit
		
		if gameplayer == player: current_turn = enemy
		elif gameplayer == enemy: current_turn = player
		
		if not check_if_round_over(): current_turn.start_turn()

func check_if_round_over() -> bool:
	for gameplayer:GamePlayer in all_gameplayers:
		if not gameplayer.have_played_this_round:
			return false
	#if you got this far...
	end_round()
	return true

func end_round() -> void:
	find_and_award_winner()
	
	var should_end_hand:bool = false
	
	for gameplayer:GamePlayer in all_gameplayers:
		gameplayer.playmat.discard_hand()
		gameplayer.have_played_this_round = false
		if gameplayer.hand.cards_in_hand.size() <= 0:
			should_end_hand = true
	
	current_suit = unset_suit
	if should_end_hand: end_hand()
	else: current_turn.start_turn()

func find_and_award_winner() -> void:
	if not check_highest_of_suit(Rules.current_prime):
		if not check_highest_of_suit(current_suit):
			var highest_value:int = 0
			var winning_gameplayer:GamePlayer = enemy
			for gameplayer:GamePlayer in all_gameplayers:
				for card:Card in gameplayer.playmat.cards_in_hand:
					if card.value > highest_value:
						highest_value = card.value
						winning_gameplayer = gameplayer
			award_trick_to_winner(winning_gameplayer)

func check_highest_of_suit(suit_to_check:StringName) -> bool:
	var suit_in_play:bool = false
	for gameplayer:GamePlayer in all_gameplayers:
		for card:Card in gameplayer.playmat.cards_in_hand:
			if card.suit == suit_to_check:
				suit_in_play = true
	
	var winning_gameplayer:GamePlayer = null
	if suit_in_play:
		var highest_value:int = 0
		for gameplayer:GamePlayer in all_gameplayers:
			for card:Card in gameplayer.playmat.cards_in_hand:
				if card.suit == suit_to_check:
					if card.value > highest_value:
						highest_value = card.value
						winning_gameplayer = gameplayer
		award_trick_to_winner(winning_gameplayer)
		return true
	
	return false

func award_trick_to_winner(winner:GamePlayer) -> void:
	winner.award_trick()
	current_turn = winner

func end_hand() -> void:
	for gameplayer:GamePlayer in all_gameplayers:
		gameplayer.complete_hand()
	UiEvents.hand_ended.emit()
	
	current_hand_size += 1
		#make this do the 2 -> 7 -> 2 curve
	start_hand()

func _unhandled_input(event: InputEvent) -> void:
	@warning_ignore("unsafe_property_access")
	if event is InputEventKey and event.pressed:
		
		@warning_ignore("unsafe_property_access")
		if event.keycode == KEY_1:
			print_debug("printing deck...")
			print_card_array_by_suit(deck.cards_in_deck)

func print_card_array_by_suit(card_array:Array[Card]) -> void:
	print("cards in array: ", card_array.size())
	var to_print_master:Array[String]
	for suit in Names.suits:
		var to_print:Array[String]
		for card:Card in card_array:
			if card.suit == suit:
				to_print.append(card.print_string)
				#would be nice to order by value
		if to_print.size() == 0: to_print.append("no cards of " + suit)
		to_print_master.append(", ".join(to_print))
	print("\n".join(to_print_master))

func print_card_array_one_line(card_array:Array[Card]) -> void:
	var to_print:Array[String]
	for card:Card in card_array:
		to_print.append(card.print_string)
	if to_print.size() == 0: to_print.append("empty")
	print(", ".join(to_print))
