extends KinematicBody2D
class_name Bunny


onready var texture: Sprite = $texture
onready var attack_timer: Timer = $attack_timer
onready var animation: AnimationPlayer = $animation
onready var spawn: Position2D = $spawn
onready var hitbox: Area2D = $hitbox
onready var hitbox_timer: Timer = $hitbox/timer
var armed_sprite := 'res://assets/bunny/armed.png'
var armed := false
var can_attack := true
var jump_count: int = 0
var velocity: Vector2
export(PackedScene) var Projectile
export(PackedScene) var hit_effect
export(PackedScene) var death_effect
export(bool) var attacking
export(float) var attack_cooldown
export(float) var invulnerability_time
export(int) var speed
export(int) var jump_speed
export(int) var fall_speed
export(int) var health


func _physics_process(delta: float) -> void:
  move()
  attack()
  
  velocity.y += fall_speed * delta
  velocity = move_and_slide(velocity, Vector2.UP)
  jump()
  animate()
  

func move() -> void:
  var direction = Input.get_action_strength('ui_right') - Input.get_action_strength('ui_left')
  velocity.x = direction * speed
  

func attack() -> void:
  if Input.is_action_just_pressed('ui_attack') and armed and can_attack:
    spawn_projectile()
    attacking = true
    can_attack = false
    set_physics_process(false)
    attack_timer.start(attack_cooldown)
  

func jump() -> void:
  if is_on_floor():
    jump_count = 0
    
  if Input.is_action_just_pressed('ui_select') and jump_count < 2:
    velocity.y = jump_speed
    jump_count += 1
  
  
func animate() -> void:
  verify_direction()
  if attacking:
    animation.play('fire')
  elif velocity.y != 0 and not attacking:
    animation.play('jump')
  elif velocity.x != 0 and not attacking:
    animation.play('run')
  elif not attacking:
    animation.play('idle')


func spawn_effect(target_effect: PackedScene) -> void:
  var effect = target_effect.instance()
  effect.global_position = global_position
  get_tree().root.call_deferred('add_child', effect)    


func update_health(body: Bug) -> void:
  if body is Bug:
    hitbox.set_deferred('monitoring', false)
    hitbox_timer.start(invulnerability_time)
    health -= body.damage
    
    if health <= 0:
      spawn_effect(death_effect)
      var _reload = get_tree().change_scene("res://scenes/management/game_over.tscn")
    else:
      spawn_effect(hit_effect)


func verify_direction() -> void:
  if velocity.x > 0:
    texture.flip_h = false
    spawn.position = Vector2(7, 3)
  elif velocity.x < 0:
    texture.flip_h = true
    spawn.position = Vector2(-7, 3)


func spawn_projectile() -> void:
  var projectile: Projectile = Projectile.instance()
  if texture.flip_h:
    projectile.direction = -1
    
  projectile.global_position = spawn.global_position
  get_tree().root.call_deferred('add_child', projectile)
  

func change_sprite() -> void:
  armed = true
  texture.texture = load(armed_sprite)


func _on_attack_timer_timeout() -> void:
  can_attack = true


func _on_hit_timeout() -> void:
  hitbox.set_deferred('monitoring', true)
