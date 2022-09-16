extends Control
class_name GameOver


onready var label: Label = $text


func _ready() -> void:
  label.text = 'Game Over\nInimigos eliminados\n' + str(Global.enemies_count)
  Global.enemies_count = 0


func _on_back_button_pressed() -> void:
  var _reload = get_tree().change_scene("res://scenes/management/level.tscn")
