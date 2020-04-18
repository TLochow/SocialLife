extends RigidBody2D

signal Impact(fitness, energy, social)

var EventType = 1

var FitnessBoost
var EnergyBoost
var SocialBoost

var state = 0

func _physics_process(delta):
	if state == 1:
		if get_position().distance_to(Vector2(0, 0)) > 800.0:
			queue_free()

func SetEventType(type, sprite, fitnessBoost, energyBoost, socialBoost):
	EventType = type
	FitnessBoost = fitnessBoost
	EnergyBoost = energyBoost
	SocialBoost  = socialBoost
	$Sprite.frame = sprite

func Collide(paddleType):
	if paddleType == EventType:
		state = 1
		set_linear_velocity(get_linear_velocity() * -2.0)

func ReachedMiddle():
	emit_signal("Impact", FitnessBoost, EnergyBoost, SocialBoost)
	queue_free()
