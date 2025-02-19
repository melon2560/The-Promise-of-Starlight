extends ColorRect

# ラベルの参照
@onready var char_name_label = $CharNameLabel
@onready var dialogue_label = $DialogueLabel
@onready var button1 = $Button1
@onready var button2 = $Button2

var current_dialogue_index = 0  # 現在の会話の位置
var is_player_turn = false  # プレイヤーのターンかどうか
var is_dialogue_active = false  # 会話中かどうか

# =======================================================
# 会話ウィンドウに表示するメイン関数
#  - character_name: 表示するキャラ名
#  - dialogue_text:  セリフ本文
#  - choices:        選択肢の配列（["選択肢1","選択肢2",...]）
#  - choice_indices: 選択肢を押したとき、process_player_choice() に送りたい番号の配列（[2,3,...]等）
#                     （指定しない or [] の場合は [0,1,2...] の連番で代わりに作る）
# =======================================================
func show_dialogue(
	character_name: String,
	dialogue_text: String,
	choices: Array,
	choice_indices: Array = []
) -> void:
	# キャラ名とセリフ表示
	char_name_label.text = character_name
	dialogue_label.text = dialogue_text
	self.show()
	char_name_label.show()
	dialogue_label.show()
	is_dialogue_active = true

	# 選択肢がないならボタン隠しておしまい
	if choices.size() == 0:
		button1.hide()
		button2.hide()
		return

	# choice_indices がなければデフォルトで連番[0..N-1]作る
	if choice_indices.size() == 0:
		var default_indices = []
		for i in range(choices.size()):
			default_indices.append(i)
		choice_indices = default_indices

	# 選択肢を表示
	show_choices(choices, choice_indices)


# =======================================================
# 選択肢ボタンを表示して、押されたら process_player_choice() を呼ぶ
#  - choices:        選択肢テキストの配列
#  - choice_indices: 各ボタンに対応したインデックス番号の配列
# =======================================================
func show_choices(choices: Array, choice_indices: Array):
	button1.hide()
	button2.hide()

	# 既存の押下イベントをいったん切ってから再接続
	if button1.pressed.is_connected(process_player_choice):
		button1.pressed.disconnect(process_player_choice)
	if button2.pressed.is_connected(process_player_choice):
		button2.pressed.disconnect(process_player_choice)

	# ボタン1
	if choices.size() > 0:
		button1.text = choices[0]
		button1.show()
		button1.pressed.connect(func():
			process_player_choice(choice_indices[0])
		)

	# ボタン2
	if choices.size() > 1:
		button2.text = choices[1]
		button2.show()
		button2.pressed.connect(func():
			process_player_choice(choice_indices[1])
		)


# =======================================================
# ボタンが押されたときに呼ばれる。インデックスで会話分岐処理
# =======================================================
func process_player_choice(choice_index: int):
	button1.hide()
	button2.hide()

	# 1回目の選択肢
	if choice_index == 0:
		# 「こんにちは！」を押した流れ
		show_dialogue(
			"エルバ",
			"こんにちは、アレン！",
			["元気？", "最近どう？"],
			[2, 3]  # ← process_player_choice に 2 or 3を渡すようにする
		)
	elif choice_index == 1:
		# 「あなたは誰ですか？」を押した流れ
		show_dialogue(
			"エルバ",
			"私はエルバです！",
			["よろしく！", "何してるの？"],
			[4, 5]  # ← 4か5を渡すようにする
		)

	# 2回目以降の選択肢
	elif choice_index == 2:
		show_dialogue(
			"エルバ",
			"元気です！",
			[]  # もう次の選択肢を用意しないなら空配列
		)
	elif choice_index == 3:
		show_dialogue(
			"エルバ",
			"最近は忙しいです！",
			[]
		)
	elif choice_index == 4:
		show_dialogue(
			"エルバ",
			"よろしくお願いします！",
			[]
		)
	elif choice_index == 5:
		show_dialogue(
			"エルバ",
			"散歩です！",
			[]
		)

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
	self.hide()  # ColorRect全体を非表示
	char_name_label.hide()  # キャラ名非表示
	dialogue_label.hide()  # セリフ非表示
	is_dialogue_active = false  # 会話中フラグをオフ

func _input(event):
	# 🔹 ダイアログが表示中 かつ ボタンが非表示のときのみ閉じる
	if event is InputEventMouseButton and event.pressed and is_dialogue_active and not button1.visible and not button2.visible:
		hide_dialogue()
