extends Hand
class_name Playmat

var running_total:int = 0

func recalculate_total() -> void:
	running_total = 0
	for card:Card in cards_in_hand:
		running_total += card.value
