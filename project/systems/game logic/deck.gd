extends Node
class_name Deck

var cards_in_deck:Array[Card]

func setup() -> void:
	populate_basic_deck()

func populate_basic_deck() -> void:
	var max_value:int = 10
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
	var card_to_draw:Card = cards_in_deck.pop_back()
	print("drew: ", card_to_draw.print_string)
	return card_to_draw
