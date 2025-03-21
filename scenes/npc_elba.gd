extends StaticBody2D

@onready var dialogue_box = $"../CanvasLayer/DialogueBox"

var player_near = false

func _process(_delta) -> void:
	if player_near and Input.is_action_just_pressed("ui_f"):
		dialogue_box.show_dialogue(self, -1)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_near = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_near = false

func get_dialogue(choice_index: int, event_flag: String = ""):
	if choice_index == -1:
		return {
			"name": "エルバ",
			"text": "こんにちは、アレン！",
			"choices": ["元気？", "最近どう？"],
			"choice_indices": [0, 1]
		}
	elif choice_index == 0:
		return {
			"name": "エルバ",
			"text": "元気です！",
			"choices": [],
			"choice_indices": []
		}
	elif choice_index == 1:
		return {
			"name": "エルバ",
			"text": "最近は忙しいです！",
			"choices": [],
			"choice_indices": []
		}
	return {}
