extends Area2D
class_name Weapon


func _on_weapon_body_entered(body) -> void:
  body.change_sprite()
  queue_free()
