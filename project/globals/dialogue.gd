extends Node

@warning_ignore_start("unused_signal")
signal new_dialogue_bark(text:String)
signal played_card(gameplayer:GamePlayer, card:Card)
@warning_ignore_restore("unused_signal")

var dialogue_stage:int = 100

func _ready() -> void:
	played_card.connect(card_played_bark)
	UiEvents.hand_ended.connect(round_ended_bark)

func card_played_bark(who_played_card:GamePlayer, card_played:Card) -> void:
	if Tutorial.hand_stage == 1:
		if dialogue_stage == 100:
			if who_played_card.controlled_by_ai:
				new_dialogue_bark.emit("PLAY A CARD HAHAHAH")
				dialogue_stage = 101
		elif dialogue_stage == 101:
			if not who_played_card.controlled_by_ai:
				new_dialogue_bark.emit("TOO SMALL HAHAHA")
				dialogue_stage = 102
		elif dialogue_stage == 102:
			if not who_played_card.controlled_by_ai:
				if card_played.value < 4:
					new_dialogue_bark.emit("HAHAHA SO PUNY CARD")
					dialogue_stage = 200
				if card_played.value > 4:
					new_dialogue_bark.emit("HAHAHA LUCKY HAHA CARD GAMES HAVE NO SKILL HAHAHA")
					dialogue_stage = 200
	
	elif Tutorial.hand_stage == 2:
		if dialogue_stage == 200:
			if who_played_card.controlled_by_ai:
				new_dialogue_bark.emit("HAVE TO FOLLOW SUIT HAHAHA")
				dialogue_stage = 201
		elif dialogue_stage == 201:
			if not who_played_card.controlled_by_ai:
				new_dialogue_bark.emit("PUNY CARD HAHAHAHA")
				dialogue_stage = 202
		elif dialogue_stage == 202:
			if not who_played_card.controlled_by_ai:
				new_dialogue_bark.emit("UNFAIR!! YOUR CARD IS TOO STRONG!!")
				dialogue_stage = 300
	
	elif Tutorial.hand_stage == 3:
		if dialogue_stage == 300 or dialogue_stage == 301:
			if not who_played_card.controlled_by_ai:
				if card_played.suit == Rules.current_prime:
					new_dialogue_bark.emit("AHH VERY NICE PRIME VERY HANDSOME")
					if dialogue_stage == 301: dialogue_stage = 400
					elif dialogue_stage == 300: dialogue_stage = 301
				elif card_played.suit != Rules.current_lead_suit:
					new_dialogue_bark.emit("AHAH FOLLOWED SUIT WINS HAHA STUPID SUN")
					if dialogue_stage == 301: dialogue_stage = 400
					elif dialogue_stage == 300: dialogue_stage = 301

func round_ended_bark() -> void:
	if Tutorial.hand_stage == 2:
		new_dialogue_bark.emit("HM........ PRIME SUITS ALWAYS WIN")
	if Tutorial.hand_stage == 3:
		new_dialogue_bark.emit("OKAY OKAY OKAY ENOUGH NEW RULES")
	if Tutorial.hand_stage == 4:
		new_dialogue_bark.emit("VERY GOOD...")
		await get_tree().create_timer(4).timeout
		new_dialogue_bark.emit("THE POINT OF THE GAME IS NOT TO WIN")
		await get_tree().create_timer(6).timeout
		new_dialogue_bark.emit("TELL ME EXACTLY HOW MANY CARDS YOU WIN HAHAHA")
		await get_tree().create_timer(5).timeout
		Tutorial.tutorial_finished.emit()
		await get_tree().create_timer(7).timeout
		new_dialogue_bark.emit("HAHA GO ON AND TELL ME THE FUTURE HAHAHA")
