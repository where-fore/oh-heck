extends Node
class_name Deck

var cards_in_deck:Array[Card]

func setup() -> void:
	populate_basic_deck()

func populate_basic_deck() -> void:
	var max_value:int = Rules.max_card_value_to_create
	for suit in Names.suits:
		var current_value_to_assign:int = 1
		while current_value_to_assign <= max_value:
			var new_card:Card = Card.new()
			new_card.setup(suit, current_value_to_assign)
			
			cards_in_deck.append(new_card)
			
			current_value_to_assign += 1
		current_value_to_assign = 1

func shuffle_deck(cards_to_shuffle_in:Array[Card] = []) -> void:
	if cards_to_shuffle_in: cards_in_deck.append_array(cards_to_shuffle_in)
	cards_in_deck.shuffle()

func draw_top_card() -> Card:
	if not cards_in_deck: push_error("deck was empty")
	var card_to_draw:Card = cards_in_deck.pop_back()
	return card_to_draw

func draw_specific_card(value:int, suit:StringName) -> Card:
	if value <= 0 or value > Rules.max_card_value_to_create:
		push_error("told to draw specific card of value: ", value, ", but that's illegal")
	if suit not in Names.suits:
		push_error("told to draw specific card of suit: ", suit, ", but that's illegal")
	
	var card_drawn:Card
	for card:Card in cards_in_deck:
		if card.suit == suit:
			if card.value == value:
				card_drawn = card
	if not card_drawn: push_error("never found card in deck: ", value, " of ", suit)
	
	cards_in_deck.erase(card_drawn)
	
	return card_drawn
