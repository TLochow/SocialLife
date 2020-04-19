extends Node

var Score = 0

func Map(value, minValue, maxValue, minResult, maxResult):
	return ((maxResult - minResult) * ((value - minValue) / (maxValue - minValue))) + minResult

func DegreesToDirectionNumber(degrees):
	while degrees < -180:
		degrees += 360
	while degrees > 180:
		degrees -= 360
	var directionNumber
	if degrees < -157.5:
		directionNumber = 2
	elif degrees < -112.5:
		directionNumber = 1
	elif degrees < -67.5:
		directionNumber = 0
	elif degrees < -22.5:
		directionNumber = 7
	elif degrees < 22.5:
		directionNumber = 6
	elif degrees < 67.5:
		directionNumber = 5
	elif degrees < 112.5:
		directionNumber = 4
	elif degrees < 157.5:
		directionNumber = 3
	else:
		directionNumber = 2
	return directionNumber
