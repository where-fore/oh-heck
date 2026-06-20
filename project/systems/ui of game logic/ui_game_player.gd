extends Control

@export var top:bool
@export var hand:UIHand
@export var playmat:UIHand
@export var score_label:Label
@export var bid_label:Label
@export var tricks_label:Label
@export var leader_label:Label
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
	
	UiEvents.new_hand_leader.connect(check_and_set_leader_label)
	UiEvents.end_bidding.connect(disable_leader_label)
	leader_label.text = ""
	
	leader_label.visible = Tutorial.score_hud_should_show
	Tutorial.score_hud_display_should_toggle.connect(toggle_visibility)

func toggle_visibility() -> void:
	leader_label.visible = !leader_label.visible

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
	var new_string:String = "Bid: "
	if gameplayer.current_bid == -1: new_string += "waiting"
	else: new_string += str(gameplayer.current_bid)
	
	bid_label.text = new_string

func set_tricks_label() -> void:
	tricks_label.text = str("Tricks: ", gameplayer.current_tricks)

func disable_leader_label() -> void:
	leader_label.text = ""

func check_and_set_leader_label(new_leader:GamePlayer) -> void:
	if new_leader == gameplayer:
		leader_label.text = "LEADER"
	else:
		leader_label.text = ""
