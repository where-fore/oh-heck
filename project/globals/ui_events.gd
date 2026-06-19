extends Node

@warning_ignore_start("unused_signal")
signal send_game_player_to_top_ui(gameplayer:GamePlayer)
signal send_game_player_to_bottom_ui(gameplayer:GamePlayer)
signal card_sent_to_discard(card:Card)
signal card_selected_to_play(gameplayer:GamePlayer, card:Card)
signal begin_bidding
signal end_bidding
signal bid_set_to(bid:int)
@warning_ignore_restore("unused_signal")
