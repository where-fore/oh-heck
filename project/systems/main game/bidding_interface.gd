extends Control

@export var textbox:LineEdit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	UiEvents.begin_bidding.connect(change_to)
	UiEvents.end_bidding.connect(change_from)
	UiEvents.player_bid_accepted.connect(bid_accepted)
	UiEvents.player_bid_rejected.connect(bid_rejected)
	
	visible = false

func change_to() -> void:
	textbox.text = ""
	visible = true

func change_from() -> void:
	visible = false
	textbox.text = ""

func bid_accepted() -> void:
	UiEvents.end_bidding.emit()

func bid_rejected() -> void:
	textbox.text = ""

func _on_submit_button_pressed() -> void:
	var user_text:String = textbox.text
	if validate_bid(textbox.text):
		UiEvents.player_bid_attempted.emit(int(user_text))
	else:
		bid_rejected()

func _on_up_pressed() -> void:
	if validate_bid(textbox.text):
		textbox.text = str(int(textbox.text) + 1)
	else: textbox.text = str(1)

func _on_down_pressed() -> void:
	if validate_bid(textbox.text):
		if int(textbox.text) > 0:
			textbox.text = str(int(textbox.text) - 1)
	else: textbox.text = str(0)

func validate_bid(text:String) -> bool:
	var passed:bool = true
	if not text.is_valid_int():
		passed = false
	if int(text) < 0:
		passed = false
	if int(text) > 100: #failsafe number, could be beaten
		passed = false
	
	return passed
