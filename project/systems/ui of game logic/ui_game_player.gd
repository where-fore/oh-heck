extends Control

@export var top:bool
@export var hand:UIHand
@export var playmat:UIHand

func _ready() -> void:
	playmat.ui_card_container.clear_cards()
	hand.ui_card_container.clear_cards()
	
	if top:
		UiEvents.send_game_player_to_top_ui.connect(hand.setup)
		UiEvents.send_game_player_to_top_ui.connect(playmat.setup)
	else:
		UiEvents.send_game_player_to_bottom_ui.connect(hand.setup)
		UiEvents.send_game_player_to_bottom_ui.connect(playmat.setup)
