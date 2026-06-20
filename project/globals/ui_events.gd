extends Node

@warning_ignore_start("unused_signal")
signal send_game_player_to_top_ui(gameplayer:GamePlayer)
signal send_game_player_to_bottom_ui(gameplayer:GamePlayer)
signal card_sent_to_discard(card:Card)
signal card_selected_to_play(gameplayer:GamePlayer, card:Card)
signal begin_bidding
signal end_bidding
signal player_bid_attempted(bid:int)
signal player_bid_accepted
signal player_bid_rejected
signal bid_added(bid:int)
signal set_prime_card(card:Card)
signal hand_ended
signal turn_started(gameplayer:GamePlayer)
signal turn_ended(gameplayer:GamePlayer)
@warning_ignore_restore("unused_signal")
