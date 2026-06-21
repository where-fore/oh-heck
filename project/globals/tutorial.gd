extends Node

@warning_ignore_start("unused_signal")
signal game_start
signal tutorial_finished
@warning_ignore_restore("unused_signal")

var hand_stage:int = 1
var max_hand_stage:int = 4 #descriptive, not prescriptive. update me

var barked_about_bid_scoring:bool = false
var barked_about_trick_scoring:bool = false
var barked_about_trick_turn_swapping:bool = false
var barked_about_leader_swapping:bool = false


#
#game rule/state toggles, and their signals
#
var hand_size_should_increment:bool = false
var hand_leaders_should_swap:bool = false
var overwriting_draw_order:bool = true
var overwriting_prime_choice:bool = true

var bidding_interface_should_show:bool = false
signal bidding_display_should_toggle
func toggle_bidding_interface() -> void:
	bidding_interface_should_show = !bidding_interface_should_show
	bidding_display_should_toggle.emit()

var prime_suit_functional:bool = false
signal prime_suit_toggle
func toggle_prime_card_functionality() -> void:
	prime_suit_functional = !prime_suit_functional
	prime_suit_toggle.emit()

var score_hud_should_show:bool = false
signal score_hud_display_should_toggle
func toggle_score_hud_display() -> void:
	score_hud_should_show = !score_hud_should_show
	score_hud_display_should_toggle.emit()
