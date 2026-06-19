extends Control

@export var top:bool
@export var hand:UIHand
@export var playmat:Container

func _ready() -> void:
	if top:
		UiEvents.send_game_player_to_top_ui.connect(hand.setup)
	else:
		UiEvents.send_game_player_to_bottom_ui.connect(hand.setup)

	for child:Node in playmat.get_children():
		child.queue_free()
