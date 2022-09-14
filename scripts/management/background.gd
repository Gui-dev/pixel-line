extends ParallaxBackground
class_name Background


onready var parallax_layer: ParallaxLayer = $layer
var layer_speed: float = 19.2


func _physics_process(delta: float) -> void:
  parallax_layer.motion_offset.x -= layer_speed * delta
