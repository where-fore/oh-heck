extends Node2D

@export var deck:Deck
@export var player:GamePlayer
@export var enemy:GamePlayer
@export var discard_pile:DiscardPile

func _ready() -> void:
	deck.setup()
	UiEvents.send_game_player_to_top_ui.emit(enemy)
	UiEvents.send_game_player_to_bottom_ui.emit(player)

func draw_a_card() -> void:
	player.hand.add_card(deck.draw_top_card())
	enemy.hand.add_card(deck.draw_top_card())

func discard_hand() -> void:
	player.hand.discard_hand()
	player.playmat.discard_hand()
	enemy.hand.discard_hand()
	enemy.playmat.discard_hand()

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

func _unhandled_input(event: InputEvent) -> void:
	@warning_ignore("unsafe_property_access")
	if event is InputEventKey and event.pressed:

		@warning_ignore("unsafe_property_access")
		if event.keycode == KEY_1:
			print_debug("printing deck...")
			print_card_array_by_suit(deck.cards_in_deck)
		
		@warning_ignore("unsafe_property_access")
		if event.keycode == KEY_2:
			print_debug("shuffling deck...")
			deck.shuffle_deck()
		
		@warning_ignore("unsafe_property_access")
		if event.keycode == KEY_3:
			print_debug("drawing card...")
			draw_a_card()
		
		@warning_ignore("unsafe_property_access")
		if event.keycode == KEY_4:
			print_debug("displaying hand...")
			print_card_array_one_line(player.hand.cards_in_hand)
		
		@warning_ignore("unsafe_property_access")
		if event.keycode == KEY_5:
			print_debug("discarding hand...")
			discard_hand()
		
		@warning_ignore("unsafe_property_access")
		if event.keycode == KEY_6:
			print_debug("displaying discard pile...")
			print_card_array_one_line(discard_pile.cards_in_hand)
		
		@warning_ignore("unsafe_property_access")
		if event.keycode == KEY_7:
			print_debug("shuffling discard pile in...")
			deck.shuffle_deck(discard_pile.return_discard_pile())
