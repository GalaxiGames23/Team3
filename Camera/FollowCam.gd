extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var current_focus
var nb_particles
export var speed = 0.1
export var dezoom: float = 1.5 
 
# Called when the node enters the scene tree for the first time.
func _ready():
	var p = get_tree().get_nodes_in_group("Player")
	dezoom *= sqrt(2)
	current_focus = p[0]
	p[0].myCamera = self
	nb_particles = $BasicParticles.amount
	$IncreaseParticles.emitting = false
	$BasicParticles.emitting = true


func _physics_process(delta):
	if current_focus:
		position = current_focus.position
		if current_focus.is_in_group("Ball"):
			if (current_focus.can_break_wall_hard):
				
				zoom += speed * Vector2(delta, delta)
				zoom = zoom.clamped(dezoom)
			

#Change the target of the camera (between player and ball)
func change_focus(new_focus):
	update_amount_particle(nb_particles)
	current_focus = new_focus
	$AnimationPlayer.play("ResetCam")
	$AnimationPlayer.get_animation("ResetCam").track_insert_key(0,0.0, zoom)
	$AnimationPlayer.get_animation("ResetCam").track_insert_key(1,0.0, offset)
	

func play_hearthquake():
	$AnimationPlayer.play("Hearthquake")

func update_amount_particle(var new_amount: int):
	if (new_amount > nb_particles):
		$IncreaseParticles.emitting = true
		$IncreaseParticles.amount = new_amount
	else:
		$IncreaseParticles.emitting = false
