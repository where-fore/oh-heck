extends Control

@export var ui_card:UICard

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	UiEvents.set_prime_card.connect(set_card_to)
	UiEvents.hand_ended.connect(clear_card)
	
	Tutorial.prime_suit_toggle.connect(toggle_visibility)
	visible = Tutorial.prime_suit_functional

func toggle_visibility() -> void:
	visible = !visible

func set_card_to(new_card:Card) -> void:
	ui_card.setup(new_card)
	Rules.current_prime = ui_card.card.suit

func clear_card() -> void:
	ui_card.unsetup()
	if ui_card.card: UiEvents.card_sent_to_discard.emit(ui_card.card)
