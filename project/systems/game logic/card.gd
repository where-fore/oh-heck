extends Resource
class_name Card

var suit:StringName = Names.suit_unassigned
var value:int = 0
var print_string:String:
	get():
		return str(value, " of ", suit)

func setup(suit_to_set:StringName, value_to_set:int) -> void:
	if suit_to_set not in Names.suits:
		push_error("card initalization failed. was given suit: ", suit_to_set, " which i didn't recognize as a valid suit")
	suit = suit_to_set
	value = value_to_set
