extends Control



func _on_video_stream_player_finished() -> void:
	await get_tree().create_timer(2).timeout
	get_tree().quit()
