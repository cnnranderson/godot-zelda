extends Node

"""
Events Singleton -- used to define events for the entire game.

This allows us to bind events anywhere across the entities used
without having to create complex hierarchies within nodes when
connecting signal subscribers.
"""

const Actions = {
	"MoveLeft": "ui_left",
	"MoveRight": "ui_right",
	"MoveDown": "ui_down",
	"MoveUp": "ui_up",
}

signal game_won
