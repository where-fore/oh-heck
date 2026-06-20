extends Node

@warning_ignore_start("unused_signal")
signal new_dialogue_bark(text:String)
@warning_ignore_restore("unused_signal")

var tutorial_hand_stage:int = 1

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
