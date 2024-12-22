extends Area2D

# 会話可能フラグ
var can_interact = false

# Playerが範囲に入ったとき
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		can_interact = true  # 会話可能状態にする
		print("会話可能になりました")  # 確認用の出力

# Playerが範囲から出たとき
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		can_interact = false  # 会話を終了
		print("会話が終了しました")  # 確認用の出力
