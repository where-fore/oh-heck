extends Control

@export var top:bool
@export var hand:UIHand
@export var playmat:UIHand
@export var score_label:Label
@export var bid_label:Label
@export var tricks_label:Label
var gameplayer:GamePlayer

func _ready() -> void:
	playmat.ui_card_container.clear_cards()
	hand.ui_card_container.clear_cards()
	
	if top:
		UiEvents.send_game_player_to_top_ui.connect(hand.setup)
		UiEvents.send_game_player_to_top_ui.connect(playmat.setup)
		UiEvents.send_game_player_to_top_ui.connect(setup)
	else:
		UiEvents.send_game_player_to_bottom_ui.connect(hand.setup)
		UiEvents.send_game_player_to_bottom_ui.connect(playmat.setup)
		UiEvents.send_game_player_to_bottom_ui.connect(setup)

func setup(gameplayer_to_assign:GamePlayer) -> void:
	gameplayer = gameplayer_to_assign
	gameplayer.points_updated.connect(set_score_label)
	gameplayer.bid_updated.connect(set_bid_label)
	gameplayer.tricks_updated.connect(set_tricks_label)
	set_score_label()
	set_bid_label()
	set_tricks_label()

func set_score_label() -> void:
	score_label.text = str("Score: ", gameplayer.overall_points)

func set_bid_label() -> void:
	bid_label.text = str("Bid: ", gameplayer.current_bid)

func set_tricks_label() -> void:
	tricks_label.text = str("Tricks: ", gameplayer.current_tricks)
