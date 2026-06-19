extends Control

@export var ui_card:UICard

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	UiEvents.set_prime_card.connect(set_card_to)
	UiEvents.hand_ended.connect(clear_card)

func set_card_to(new_card:Card) -> void:
	ui_card.setup(new_card)
	Rules.current_prime = ui_card.card.suit

func clear_card() -> void:
	UiEvents.card_sent_to_discard.emit(ui_card.card)
