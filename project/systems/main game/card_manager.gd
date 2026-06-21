extends Node2D

@export var deck:Deck
@export var player:GamePlayer
@export var enemy:GamePlayer
@onready var all_gameplayers:Array[GamePlayer] = [player, enemy]
@export var discard_pile:DiscardPile
var current_turn:GamePlayer
var next_leader_index:int = 0
var current_hand_size:int = 3
var max_starting_hand_size:int = 7
var current_bid_sum:int = 0

func _ready() -> void:
	deck.setup()
	UiEvents.send_game_player_to_top_ui.emit(enemy)
	UiEvents.send_game_player_to_bottom_ui.emit(player)
	UiEvents.card_selected_to_play.connect(check_and_play_card)
	UiEvents.player_bid_attempted.connect(attempt_player_bid)
	UiEvents.bid_added.connect(sum_bid)
	
	current_turn = enemy
	next_leader_index = all_gameplayers.find(enemy)
	
	enemy.controlled_by_ai = true
	enemy.hand_hidden = true
	
	Tutorial.game_start.connect(start_hand)

func sum_bid(new_bid:int) -> void:
	current_bid_sum += new_bid

func attempt_player_bid(bid:int) -> void:
	if Rules.validate_bid(bid, current_bid_sum, current_hand_size):
		current_bid_sum += bid
		player.current_bid = bid
		UiEvents.player_bid_accepted.emit()
	else:
		UiEvents.player_bid_rejected.emit()

func start_hand() -> void:
	deck.shuffle_deck(discard_pile.return_discard_pile())
	
	if Tutorial.overwriting_draw_order:
		draw_hand_for_tutorial()
	else:
		var cards_dealt_to_all:int = 0
		while cards_dealt_to_all < current_hand_size:
			for gameplayer:GamePlayer in all_gameplayers:
				gameplayer.hand.add_card(deck.draw_top_card())
			cards_dealt_to_all += 1
	
	if Tutorial.prime_suit_functional:
		if not Tutorial.overwriting_prime_choice:
			UiEvents.set_prime_card.emit(deck.draw_top_card())
	
	current_turn = all_gameplayers[next_leader_index]
	
	if Tutorial.bidding_interface_should_show:
		await collect_bids()
	
	start_next_turn()

func draw_hand_for_tutorial() -> void:
	match Tutorial.hand_stage:
		1: #compare numbers: can win one but definitely lose at least one
			player.hand.add_card(deck.draw_specific_card(7, Names.suit_devil))
			player.hand.add_card(deck.draw_specific_card(2, Names.suit_devil))
			enemy.hand.add_card(deck.draw_specific_card(8, Names.suit_devil))
			enemy.hand.add_card(deck.draw_specific_card(4, Names.suit_devil))
		
		2: #suit following: enemy starts with sun, you have to follow and lose
			player.hand.add_card(deck.draw_specific_card(9, Names.suit_moon))
			player.hand.add_card(deck.draw_specific_card(4, Names.suit_sun))
			enemy.hand.add_card(deck.draw_specific_card(7, Names.suit_sun))
			enemy.hand.add_card(deck.draw_specific_card(8, Names.suit_moon))
		
		3: #primes suit
			player.hand.add_card(deck.draw_specific_card(2, Names.suit_devil))
			player.hand.add_card(deck.draw_specific_card(5, Names.suit_sun))
			enemy.hand.add_card(deck.draw_specific_card(3, Names.suit_moon))
			enemy.hand.add_card(deck.draw_specific_card(6, Names.suit_moon))
			
			Tutorial.toggle_prime_card_functionality()
			UiEvents.set_prime_card.emit(deck.draw_specific_card(8, Names.suit_devil))
		
		4: #bidding - you beat enemy handily first, he says it's not about taking them all...
			player.hand.add_card(deck.draw_specific_card(6, Names.suit_devil))
			player.hand.add_card(deck.draw_specific_card(4, Names.suit_moon))
			player.hand.add_card(deck.draw_specific_card(4, Names.suit_sun))
			enemy.hand.add_card(deck.draw_specific_card(3, Names.suit_moon))
			enemy.hand.add_card(deck.draw_specific_card(3, Names.suit_sun))
			enemy.hand.add_card(deck.draw_specific_card(1, Names.suit_moon))

func end_hand_for_tutorial() -> void:
	match Tutorial.hand_stage:
		1:
			pass
		
		2:
			pass
		
		3:
			Tutorial.overwriting_prime_choice = false
		
		4:
			Tutorial.hand_size_should_increment = true
			Tutorial.hand_leaders_should_swap = true
			next_leader_index = all_gameplayers.find(player)
			Tutorial.overwriting_draw_order = false
			Tutorial.toggle_bidding_interface()
			Tutorial.toggle_score_hud_display()
	
	Tutorial.hand_stage += 1

func collect_bids() -> bool:
	
	var bidding_gameplayers:Array[GamePlayer]
	bidding_gameplayers.append(all_gameplayers[next_leader_index])
	for gameplayer:GamePlayer in all_gameplayers:
		if gameplayer not in bidding_gameplayers:
			bidding_gameplayers.append(gameplayer)
	
	for gameplayer:GamePlayer in bidding_gameplayers:
		if gameplayer.controlled_by_ai:
			gameplayer.ai_choose_bid(current_bid_sum, current_hand_size)
		else:
			UiEvents.begin_bidding.emit()
			await UiEvents.end_bidding
	
	return true

func check_and_play_card(gameplayer:GamePlayer, card:Card) -> void:
	if gameplayer == current_turn:
		gameplayer.play_card(card)
		if Rules.current_lead_suit == Rules.unset_suit:
			Rules.current_lead_suit = card.suit
		
		if gameplayer == player: current_turn = enemy
		elif gameplayer == enemy: current_turn = player
		
		if not check_if_round_over(): start_next_turn()

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
	
	await get_tree().create_timer(1.25).timeout
	
	for gameplayer:GamePlayer in all_gameplayers:
		gameplayer.playmat.discard_hand()
		gameplayer.have_played_this_round = false
		if gameplayer.hand.cards_in_hand.size() <= 0:
			should_end_hand = true
	
	
	Rules.current_lead_suit = Rules.unset_suit
	if should_end_hand: end_hand()
	else: start_next_turn()

func start_next_turn() -> void:
	for card:Card in current_turn.hand.cards_in_hand:
			card.available_to_play = true
	
	var cards_of_current_suit:int = 0
	for card:Card in current_turn.hand.cards_in_hand:
		if card.suit != Rules.current_lead_suit:
			card.available_to_play = false
		if card.suit == Rules.current_lead_suit:
			cards_of_current_suit += 1
	
	if cards_of_current_suit == 0:
		for card:Card in current_turn.hand.cards_in_hand:
				card.available_to_play = true
	
	current_turn.start_turn()

func find_and_award_winner() -> void:
	if not check_highest_of_suit(Rules.current_prime):
		if not check_highest_of_suit(Rules.current_lead_suit):
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
	UiEvents.trick_won.emit(winner)
	winner.award_trick()
	current_turn = winner
	
	if Tutorial.hand_stage > Tutorial.max_hand_stage + 1 and not Tutorial.barked_about_trick_turn_swapping:
		if winner.hand.cards_in_hand.size() > 2:
			if winner.controlled_by_ai:
				Dialogue.new_dialogue_bark.emit("I WIN! HAHA MY TURN NOW HAHAHA")
				Tutorial.barked_about_trick_turn_swapping = true

func end_hand() -> void:
	for gameplayer:GamePlayer in all_gameplayers:
		gameplayer.complete_hand()
	
	if Tutorial.hand_stage == 1:
		await get_tree().create_timer(1).timeout
	if Tutorial.hand_stage == 2:
		await get_tree().create_timer(7).timeout
	elif Tutorial.hand_stage == 3:
		await get_tree().create_timer(5).timeout
	UiEvents.hand_ended.emit()
	
	current_bid_sum = 0
	
	if Tutorial.hand_size_should_increment:
		if current_hand_size <= max_starting_hand_size:
			current_hand_size += 1
	
	if Tutorial.hand_leaders_should_swap:
		next_leader_index += 1
		if next_leader_index > all_gameplayers.size() - 1: next_leader_index = 0
		UiEvents.new_hand_leader.emit(all_gameplayers[next_leader_index])
		if not Tutorial.barked_about_leader_swapping and Tutorial.hand_stage > Tutorial.max_hand_stage + 2:
			if all_gameplayers[next_leader_index].controlled_by_ai:
				Tutorial.barked_about_leader_swapping = true
				Dialogue.new_dialogue_bark.emit("MY TURN TO START HAHAHA HM... WHAT TO BID...")
	
	if Tutorial.hand_stage < Tutorial.max_hand_stage:
		await get_tree().create_timer(3).timeout
	elif Tutorial.hand_stage == Tutorial.max_hand_stage:
		await Tutorial.tutorial_finished
	end_hand_for_tutorial()
	
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
