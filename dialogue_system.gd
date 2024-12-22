extends Node

# ラベルの参照
@onready var char_name_label = get_node("DialogueBox/CharNameLabel")
@onready var dialogue_label = get_node("DialogueBox/DialogueLabel")
@onready var color_rect = get_node("DialogueBox")

# 会話ウィンドウを表示
func show_dialogue(text: String):
	dialogue_label.text = text  # テキストを表示
	color_rect.show()  # 背景表示
	char_name_label.show()  # キャラ名表示
	dialogue_label.show()  # セリフ表示

# 会話ウィンドウを非表示
func hide_dialogue():
	color_rect.hide()
	char_name_label.hide()
	dialogue_label.hide()
