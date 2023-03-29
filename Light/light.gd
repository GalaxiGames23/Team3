extends StaticBody2D

export(int, 0, 255) var  red = 255
export(int, 0, 255) var  green = 255
export(int, 0, 255) var  blue = 255
export(int, 0, 100) var  a = 30
export(float, 0, 1) var  energy = 0.5

func _ready():
	$Light2D.energy=energy*0.05
	$Light2D.color.r=red
	$Light2D.color.g=green
	$Light2D.color.b=blue
	$Light2D.color.a=a
