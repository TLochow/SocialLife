extends Node2D

var EVENTSCENE = preload("res://Scenes/Event.tscn")

var Fitness = 50.0
var Energy = 50.0
var Social = 50.0

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		SceneChanger.EndGame()

func _ready():
	$Paddles/RedPaddle.SetPaddleType(1)
	$Paddles/GreenPaddle.SetPaddleType(2)
	$Paddles/BluePaddle.SetPaddleType(3)

func _process(delta):
	$Camera2D/UI/Control/Scores/EnergyBar.value = Energy
	$Camera2D/UI/Control/Scores/FitnessBar.value = Fitness
	$Camera2D/UI/Control/Scores/SocialBar.value = Social

func _on_EventSpawnTimer_timeout():
	SpawnNewEvent()

func SpawnNewEvent():
	var event = EVENTSCENE.instance()
	var angle = rand_range(-PI, PI)
	var pos = Vector2(cos(angle), sin(angle))
	pos *= 800.0
	event.set_position(pos)
	event.set_linear_velocity(pos.normalized() * -80.0)
	
	var eventType = randi() % 10
	
	event.SetEventType(1, 0, 1.0, -1.0, 0.0)
	
	event.connect("Impact", self, "onEventImpact")
	
	$Events.add_child(event)

func onEventImpact(fitness, energy, social):
	Fitness = clamp(Fitness + fitness, 0.0, 100.0)
	Energy = clamp(Energy + energy, 0.0, 100.0)
	Social = clamp(Social + social, 0.0, 100.0)

func _on_Middle_body_entered(body):
	body.ReachedMiddle()
