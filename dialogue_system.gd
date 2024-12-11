extends Node

@onready var dialogue_node = $Dialogue
@onready var char_name_label = dialogue_node.get_node("CharNameLabel")
@onready var dialogue_label = dialogue_node.get_node("DialogueLabel")

func _ready():
	print("Dialogue Node: ", dialogue_node)
	print("CharNameLabel: ", char_name_label)
	print("DialogueLabel: ", dialogue_label)
