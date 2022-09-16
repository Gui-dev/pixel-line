extends KinematicBody2D
class_name Bug


var velocity: Vector2
var direction = 1
var player_ref = null
onready var texture: Sprite = $texture
onready var raycast: RayCast2D = $raycast
export(PackedScene) var hit_effect
export(PackedScene) var death_effect
export(int) var speed
export(int) var damage
export(int) var health
export(bool) var ground_enemy


func _physics_process(_delta: float) -> void:
  if ground_enemy:
    on_wall()
    velocity.x = speed * direction
  elif player_ref != null and not ground_enemy:
    var dir: Vector2 = (player_ref.global_position - global_position)  
      
    if dir.length() < 5:
      velocity = Vector2.ZERO
    else:
      velocity = dir.normalized() * speed
            
    verify_direction()
  elif not ground_enemy:
    velocity = Vector2.ZERO
    verify_direction()
    
  velocity = move_and_slide(velocity)


func verify_direction() -> void:
  if velocity.x > 0:
    texture.flip_h = false
  elif velocity.x < 0:
    texture.flip_h = true


func update_health(amount) -> void:
  health -= amount
  
  if health <= 0:
    spawn_effect(death_effect)
    Global.enemies_count += 1
    queue_free()
  else:
    spawn_effect(hit_effect)


func on_wall() -> void:
  if is_on_wall() or not raycast.is_colliding():
    direction *= -1
    scale.x *= -1 


func spawn_effect(target_effect: PackedScene) -> void:
  var effect = target_effect.instance()
  effect.global_position = global_position
  get_tree().root.call_deferred('add_child', effect)


func _on_detection_area_body_entered(body) -> void:
  player_ref = body


func _on_detection_area_body_exited(_body) -> void:
  player_ref = null
