extends Node

const points_per_bid_success:int = 10
const points_per_trick:int = 1

const max_card_value_to_create:int = 9

var current_prime:StringName

func validate_bid(attempted_bid:int, current_bid_sum:int, current_maximum_hand_size:int) -> bool:
	if current_bid_sum > 0:
		if attempted_bid + current_bid_sum == current_maximum_hand_size:
			return false
	
	return true
