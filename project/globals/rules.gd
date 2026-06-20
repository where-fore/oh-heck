extends Node

const points_per_bid_success:int = 10
const points_per_trick:int = 1

const max_card_value_to_create:int = 9

var current_prime:StringName
var current_lead_suit:StringName = unset_suit
const unset_suit:StringName = &"SUIT NOT SET"

func validate_bid(_attempted_bid:int, _current_bid_sum:int, _current_maximum_hand_size:int) -> bool:
	#if current_bid_sum > 0:
		#if attempted_bid + current_bid_sum == current_maximum_hand_size:
			#return false
	
	return true
