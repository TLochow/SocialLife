extends Area2D

var PaddleType

var IsActive = false

var Angle = 0.0
var IdleRotation = 0.1

func _ready():
	Angle = rand_range(-PI, PI)
	if randi() % 2 == 0:
		IdleRotation *= -1

func _process(delta):
	if not IsActive:
		Angle += IdleRotation * delta
	
	while Angle < -PI:
		Angle += TAU
	while Angle > PI:
		Angle -= TAU
	
	rotation_degrees = rad2deg(Angle)

func SetPaddleType(var type):
	PaddleType = type
	match type:
		1:
			$Sprite.modulate = Color(255, 0, 0)
			set_collision_mask_bit(0, true)
		2:
			$Sprite.modulate = Color(0, 255, 0)
			set_collision_mask_bit(1, true)
		3:
			$Sprite.modulate = Color(0, 0, 255)
			set_collision_mask_bit(2, true)

func _on_Paddle_body_entered(body):
	body.Collide(PaddleType)
