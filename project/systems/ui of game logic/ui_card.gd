extends Control
class_name UICard

var card:Card
@export var colour_swatch:ColorRect
@export var value_label:Label
@export var upside_down_value_label:Label

@export var angel_icon:TextureRect
@export var devil_icon:TextureRect
@export var moon_icon:TextureRect
@export var sun_icon:TextureRect
@onready var icons:Array[TextureRect] = [angel_icon, devil_icon, moon_icon, sun_icon]
signal ui_card_selected(ui_card:UICard)

func setup(card_to_assign:Card) -> void:
	
	card = card_to_assign
	
	disable_all_icons()
	
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
	
	value_label.text = str(card.value)
	upside_down_value_label.text = str(card.value)

func disable_all_icons() -> void:
	for icon:TextureRect in icons:
		icon.visible = false

func _on_button_pressed() -> void:
	ui_card_selected.emit(self)
