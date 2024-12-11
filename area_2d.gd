extends Area2D

func _on_body_entered(body: Node2D):
	if body.name == "Player":  # プレイヤーかどうか確認
		var canvas_layer = get_node("/root/Map1/CanvasLayer")  # CanvasLayerノードを取得
		canvas_layer.start_dialogue("エルバ", ["こんにちは！", "冒険者よ、気をつけて旅を続けてね！"])
