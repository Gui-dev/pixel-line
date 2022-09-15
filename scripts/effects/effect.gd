extends AnimatedSprite
class_name Effect


func _ready() -> void:
  play('idle')


func _on_animation_finished() -> void:
  queue_free()
