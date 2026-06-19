extends Control
class_name UICard

var card:Card
var should_be_hidden:bool = false
@export var colour_swatch:ColorRect
@export var darkener:ColorRect
@export var value_label:Label
@export var upside_down_value_label:Label

@export var angel_icon:TextureRect
@export var devil_icon:TextureRect
@export var moon_icon:TextureRect
@export var sun_icon:TextureRect
@export var back_icon:TextureRect
@onready var icons:Array[TextureRect] = [angel_icon, devil_icon, moon_icon, sun_icon]
signal ui_card_selected(ui_card:UICard)

func setup(card_to_assign:Card) -> void:
	card = card_to_assign
	card.availablility_updated.connect(check_to_darken)
	disable_all_icons()
	set_icon()
	set_labels()

func set_icon() -> void:
	match card.suit:
		Names.suit_devil:
			colour_swatch.color = Names.devil_colour
			devil_icon.visible = true
		Names.suit_angel:
			colour_swatch.color = Names.angel_colour
			angel_icon.visible = true
		Names.suit_sun:
			colour_swatch.color = Names.sun_colour
			sun_icon.visible = true
		Names.suit_moon:
			colour_swatch.color = Names.moon_colour
			moon_icon.visible = true

func set_labels() -> void:
	value_label.text = str(card.value)
	upside_down_value_label.text = str(card.value)

func hide_card() -> void:
	should_be_hidden = true
	colour_swatch.color = Names.basic_color
	value_label.visible = false
	upside_down_value_label.visible = false
	disable_all_icons()
	back_icon.visible = true
	enable_darkener()

func show_card() -> void:
	should_be_hidden = false
	value_label.visible = true
	upside_down_value_label.visible = true
	set_icon()
	set_labels()
	disable_darkener()

func check_to_darken() -> void:
	if not card.available_to_play: enable_darkener()
	elif card.available_to_play and not should_be_hidden: disable_darkener()

func enable_darkener() -> void:
	darkener.visible = true

func disable_darkener() -> void:
	darkener.visible = false

func disable_all_icons() -> void:
	for icon:TextureRect in icons:
		icon.visible = false

func _on_button_pressed() -> void:
	if card.available_to_play: ui_card_selected.emit(self)
