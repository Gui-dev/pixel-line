extends Area2D
class_name Projectile


var direction: int = 1
onready var texture: Sprite = $texture
export(int) var speed
export(int) var damage


func _ready() -> void:
  if direction == -1:
    texture.flip_h = true
    

func _physics_process(_delta: float) -> void:
  translate(Vector2(speed * direction, 0))


func _on_projectile_body_entered(body: Node) -> void:
  body.update_health(damage)
  queue_free()


func _on_notifier_screen_exited() -> void:
  queue_free()
