class_name Globals
extends Node

static var game_node: Game

static var players: Array[PlayerInfo] = [preload("uid://cxg4y4vhfhqlb"), preload("uid://8rh52pobuejj")]

static var round_number := 0

# When the next round begins, should we reset all stats?
# as in, is the game just beginning at that point?
static var should_initialize_player_stats := true