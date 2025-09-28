extends Node

# shop ui and trap player communication
signal trap_picked(type: TrapInfo)
signal trap_placed

signal player_hurt

signal goal_reached

# to be emitted by game node, recieved by main fsm
signal ready_to_end_round