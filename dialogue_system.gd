extends Node

# ラベルの参照
@onready var char_name_label = get_node("DialogueBox/CharNameLabel")
@onready var dialogue_label = get_node("DialogueBox/DialogueLabel")
@onready var color_rect = get_node("DialogueBox")

# 会話データ
var dialogue_data = [
	{
		"npc": "こんにちは！エルバです。",
		"player_choices": [
			"こんにちは！",
			"あなたは誰ですか？"
		]
	},
	{
		"npc": "ここは小さな村の入り口です。",
		"player_choices": [
			"ありがとう！",
			"興味ないよ。"
		]
	}
]

var current_dialogue_index = 0  # 現在の会話の位置
var is_player_turn = false  # プレイヤーのターンかどうか

var is_dialogue_active = false

# 会話ウィンドウを表示
func show_dialogue(text: String):
	dialogue_label.text = text  # テキストを表示
	color_rect.show()  # 背景表示
	char_name_label.show()  # キャラ名表示
	dialogue_label.show()  # セリフ表示
	is_dialogue_active = true  # 会話中フラグをオン

# 会話ウィンドウを非表示
func hide_dialogue():
	color_rect.hide()
	char_name_label.hide()
	dialogue_label.hide()
	is_dialogue_active = false  # 会話中フラグをオフ
	
func _ready():
	set_process_input(true)  # 入力を監視するように設定
	print("Searching for nodes...")
	print("CharNameLabel: ", get_node_or_null("DialogueBox/CharNameLabel"))
	print("DialogueLabel: ", get_node_or_null("DialogueBox/DialogueLabel"))
	print("ColorRect: ", get_node_or_null("DialogueBox"))

	# Global Positionのデバッグ
	print("DialogueBox Global Position: ", $DialogueBox.global_position)
	print("Label Global Position: ", $DialogueBox/Label.global_position)

	
	# マウス入力を監視
	set_process_input(true)
	
# マウスクリックを検知
func _input(event):
	if Input.is_action_pressed("ui_click") and is_dialogue_active:
		hide_dialogue()  # 会話を終了
