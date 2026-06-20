extends Control
class_name UIHand

var game_player:GamePlayer
@export var playmat:bool = false

@export_category("Initialization")
@export var ui_card_container:UICardContainer
@export var not_turn_indicator:ColorRect
@export var UICard_base_scene:PackedScene
@export var trick_winning:Control
@onready var base_turn_alpha:float = not_turn_indicator.color.a

func _ready() -> void:
	UiEvents.turn_started.connect(check_and_show_turn_indicator)
	UiEvents.turn_ended.connect(check_and_hide_turn_indicator)
	
	trick_winning.visible = true
	trick_winning.scale = Vector2(0,0)
	not_turn_indicator.visible = false

func setup(game_player_to_assign:GamePlayer) -> void:
	game_player = game_player_to_assign
	
	recreate_hand()
	if playmat:
		game_player.playmat.card_added.connect(create_ui_card)
		game_player.playmat.card_removed.connect(delete_ui_card)
		UiEvents.trick_won.connect(celebrate_trick_taken)
	else:
		game_player.hand.card_added.connect(create_ui_card)
		game_player.hand.card_removed.connect(delete_ui_card)
		not_turn_indicator.visible = true

func check_and_show_turn_indicator(player_whose_turn_started:GamePlayer) -> void:
	if playmat:
		return
	if player_whose_turn_started == game_player:
		await fade_animation(0, not_turn_indicator)
		not_turn_indicator.visible = false

func check_and_hide_turn_indicator(player_whose_turn_ended:GamePlayer) -> void:
	if playmat:
		return
	if player_whose_turn_ended == game_player:
		not_turn_indicator.visible = true
		fade_animation(base_turn_alpha, not_turn_indicator)

func play_card_from_ui_card(ui_card:UICard) -> void:
	UiEvents.card_selected_to_play.emit(game_player, ui_card.card)

func recreate_hand() -> void:
	ui_card_container.clear_cards()
	for card:Card in game_player.hand.cards_in_hand:
		create_ui_card(card)

func fade_animation(target_alpha:float, target_object:ColorRect) -> bool:
	var tween:Tween = create_tween()
	var target_color:Color = target_object.color
	target_color.a = target_alpha
	tween.tween_property(target_object, "color", target_color, 0.25)
	await tween.finished
	return true

func create_ui_card(card_to_assign:Card) -> void:
	var new_ui_card:UICard = UICard_base_scene.instantiate()
	ui_card_container.add_child(new_ui_card)
	new_ui_card.setup(card_to_assign)
	if game_player.hand_hidden and not playmat:
		new_ui_card.hide_card()
	
	if not playmat:
		new_ui_card.ui_card_selected.connect(play_card_from_ui_card)

func delete_ui_card(card_to_delete:Card) -> void:
	var deleted:bool = false
	
	for ui_card:UICard in ui_card_container.get_children():
		if ui_card.card == card_to_delete:
			ui_card.unsetup()
			ui_card.queue_free()
			deleted = true
	
	if not deleted: push_error("couldn't find ui card to delete: ", card_to_delete.print_string)

func celebrate_trick_taken(winner:GamePlayer) -> void:
	if winner == game_player:
		var in_tween:Tween = create_tween()
		in_tween.set_trans(Tween.TRANS_ELASTIC)
		in_tween.set_ease(Tween.EASE_OUT)
		in_tween.tween_property(trick_winning, "scale", Vector2(1,1), 1)
		
		await get_tree().create_timer(2).timeout
		
		var out_tween:Tween = create_tween()
		out_tween.set_trans(Tween.TRANS_ELASTIC)
		out_tween.set_ease(Tween.EASE_OUT)
		out_tween.tween_property(trick_winning, "scale", Vector2(0,0), 1)
		
