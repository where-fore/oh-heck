extends Control
class_name UICard

var card:Card
@export var colour_swatch:ColorRect
@export var value_label:Label

func setup(card_to_assign:Card) -> void:
	card = card_to_assign
	match card.suit:
		Names.suit_demon:
			colour_swatch.color = Names.demon_colour
		Names.suit_angel:
			colour_swatch.color = Names.angel_colour
		Names.suit_sun:
			colour_swatch.color = Names.sun_colour
		Names.suit_moon:
			colour_swatch.color = Names.moon_colour
	
	value_label.text = str(card.value)
