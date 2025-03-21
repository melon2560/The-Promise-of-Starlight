extends StaticBody2D

@onready var dialogue_box = $"../CanvasLayer/DialogueBox"

var player_near = false
var event_flag = ""  # ✅ 特定のイベントを管理するフラグ

func _process(_delta) -> void:
	if player_near and Input.is_action_just_pressed("ui_f"):
		dialogue_box.show_dialogue(self, -1)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_near = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_near = false

func get_dialogue(choice_index: int, event_flag_passed: String) -> Dictionary:
	event_flag = event_flag_passed  # ✅ 渡されたフラグを保存

	if choice_index == -1:
		return {
			"name": "旅商人",
			"text": "この先の森には魔物が出る。\n本当に行くのか？",
			"choices": ["行く", "やめる"],
			"choice_indices": [0, 1]
		}
	elif choice_index == 0:
		return {
			"name": "旅商人",
			"text": "気をつけてな！",
			"choices": [],
			"choice_indices": [],
			"event_flag": "change_scene"  # ✅ マップ切り替えイベントを付与
		}
	elif choice_index == 1:
		return {
			"name": "旅商人",
			"text": "じゃあまたな！",
			"choices": [],
			"choice_indices": []
		}
	return {}

# ✅ `hide_dialogue()` の後にイベントフラグをチェックしてマップ切り替え
func end_conversation() -> void:
	if event_flag == "change_scene":
		if get_tree() != null:
			get_tree().change_scene_to_file("res://scenes/ForestRoad.tscn")
	event_flag = ""  # ✅ フラグをリセット
