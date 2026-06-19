extends Control
class_name UIHand

var game_player:GamePlayer
@export var playmat:bool = false

@export_category("Initialization")
@export var ui_card_container:UICardContainer
@export var UICard_base_scene:PackedScene

func setup(game_player_to_assign:GamePlayer) -> void:
	game_player = game_player_to_assign
	recreate_hand()
	if playmat:
		game_player.playmat.card_added.connect(create_ui_card)
		game_player.playmat.card_removed.connect(delete_ui_card)
	else:
		game_player.hand.card_added.connect(create_ui_card)
		game_player.hand.card_removed.connect(delete_ui_card)

func play_card_from_ui_card(ui_card:UICard) -> void:
	UiEvents.card_selected_to_play.emit(game_player, ui_card.card)

func recreate_hand() -> void:
	ui_card_container.clear_cards()
	for card:Card in game_player.hand.cards_in_hand:
		create_ui_card(card)

func create_ui_card(card_to_assign:Card) -> void:
	var new_ui_card:UICard = UICard_base_scene.instantiate()
	ui_card_container.add_child(new_ui_card)
	new_ui_card.setup(card_to_assign)
	
	if not playmat:
		new_ui_card.ui_card_selected.connect(play_card_from_ui_card)

func delete_ui_card(card_to_delete:Card) -> void:
	var deleted:bool = false
	
	for ui_card:UICard in ui_card_container.get_children():
		if ui_card.card == card_to_delete:
			ui_card.queue_free()
			deleted = true
	
	if not deleted: push_error("couldn't find ui card to delete: ", card_to_delete.print_string)
