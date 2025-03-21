extends ColorRect

# ラベルの参照
@onready var char_name_label = $CharNameLabel
@onready var dialogue_label = $DialogueLabel
@onready var button1 = $Button1
@onready var button2 = $Button2

var current_dialogue_index = 0  # 現在の会話の位置
var is_player_turn = false  # プレイヤーのターンかどうか
var is_dialogue_active = false  # 会話中かどうか
var npc_script = null  # 💡 どの NPC かを保存する
var last_choice = -1  # ✅ 最後に選んだ選択肢を記録
var event_flag

# =======================================================
# 会話を開始
# =======================================================
func show_dialogue(npc: Object, choice_index: int = -1) -> void:
	npc_script = npc  # ✅ NPC を記録
	
	# 🔹 choice_index が -1 の場合は最初の会話
	var dialogue_data = npc_script.get_dialogue(choice_index, "")

	# 🔹 取得した会話データを UI にセット
	char_name_label.text = dialogue_data["name"]
	dialogue_label.text = dialogue_data["text"]
	self.show()
	char_name_label.show()
	dialogue_label.show()
	is_dialogue_active = true

	# 🔹 選択肢の表示
	show_choices(dialogue_data["choices"], dialogue_data["choice_indices"])

# =======================================================
# 選択肢をボタンにセット
# =======================================================
func show_choices(choices: Array, choice_indices: Array):
	button1.hide()
	button2.hide()

	# 既存の押下イベントを削除
	if button1.pressed.is_connected(process_player_choice):
		button1.pressed.disconnect(process_player_choice)
	if button2.pressed.is_connected(process_player_choice):
		button2.pressed.disconnect(process_player_choice)

	# ボタン1
	if choices.size() > 0:
		button1.text = choices[0]
		button1.show()
		button1.pressed.connect(process_player_choice.bind(choice_indices[0]))  # 🔹 bind() を使う

	# ボタン2
	if choices.size() > 1:
		button2.text = choices[1]
		button2.show()
		button2.pressed.connect(process_player_choice.bind(choice_indices[1]))  # 🔹 bind() を使う

# =======================================================
# 選択肢を選んだときに NPC の get_dialogue() を呼ぶ
# =======================================================
func process_player_choice(choice_index: int):
	# 🔹 NPC から次の会話データを取得
	# 🔹 まず get_dialogue() をフラグなしで取得
	var dialogue_data = npc_script.get_dialogue(choice_index, "")

	# 🔹 event_flag が dialogue_data に含まれているなら取得
	event_flag = dialogue_data.get("event_flag", "")

	# 🔹 event_flag を get_dialogue() に渡して再取得
	dialogue_data = npc_script.get_dialogue(choice_index, event_flag)

	char_name_label.text = dialogue_data["name"]
	dialogue_label.text = dialogue_data["text"]
	show_choices(dialogue_data["choices"], dialogue_data["choice_indices"])

	# 🔹 選択肢がない（最後の会話）なら自動で hide_dialogue() を呼ぶ
	if dialogue_data["choices"].size() == 0:
		_input(InputEventMouseButton)

# 初期化処理
func _ready():
	# Anchorをちゃんと設定
	self.anchor_left = 0
	self.anchor_right = 1
	self.anchor_top = 0
	self.anchor_bottom = 1

	# _ready() の後にサイズ変更を適用する
	call_deferred("set_size_and_position", 
		Vector2(0, DisplayServer.window_get_size().y + 300), 
		Vector2(DisplayServer.window_get_size().x, 200))

	# 初期状態で非表示
	hide_dialogue()

# カスタム関数で位置とサイズを設定
func set_size_and_position(new_position: Vector2, new_size: Vector2):
	self.set_deferred("position", new_position)
	self.set_deferred("size", new_size)

	# 初期状態で非表示
	hide_dialogue()
	
	# 入力を監視
	set_process_input(true)
	
	# 会話ウィンドウを非表示
func hide_dialogue():
	self.hide()
	char_name_label.hide()
	dialogue_label.hide()
	is_dialogue_active = false
	
	if event_flag == "change_scene":
		npc_script.end_conversation()

func _input(event):
	# 🔹 ダイアログが表示中 かつ ボタンが非表示のときのみ閉じる
	if event is InputEventMouseButton and event.pressed and is_dialogue_active and not button1.visible and not button2.visible:
		hide_dialogue()
