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
	FitnessBoost = fitnessBoost * 0.5
	EnergyBoost = energyBoost * 0.5
	SocialBoost  = socialBoost * 0.5
	$Sprite.frame = sprite
	
	$Glow/Red.visible = type == 1
	$Glow/Green.visible = type == 2
	$Glow/Blue.visible = type == 3
	
	$Particles/SocialPlus.emitting = socialBoost > 0
	$Particles/SocialMinus.emitting = socialBoost < 0
	$Particles/FitnessPlus.emitting = fitnessBoost > 0
	$Particles/FitnessMinus.emitting = fitnessBoost < 0
	$Particles/EnergyPlus.emitting = energyBoost > 0
	$Particles/EnergyMinus.emitting = energyBoost < 0

func Collide(paddleType):
	if paddleType == EventType:
		state = 1
		set_linear_velocity(get_linear_velocity() * -2.0)

func ReachedMiddle():
	emit_signal("Impact", FitnessBoost, EnergyBoost, SocialBoost)
	queue_free()
