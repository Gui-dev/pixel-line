extends Control
class_name Menu


func _on_start_pressed() -> void:
  var _start = get_tree().change_scene("res://scenes/management/level.tscn")


func _on_quit_pressed() -> void:
  get_tree().quit()
