extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var current_focus
var nb_particles
# Called when the node enters the scene tree for the first time.
func _ready():
	var p = get_tree().get_nodes_in_group("Player")
	print(get_tree().get_nodes_in_group("Player"))
	current_focus = p[0]
	nb_particles = $BasicParticles.amount
	$IncreaseParticles.emitting = false
	$BasicParticles.emitting = true


func _physics_process(delta):
	if current_focus:
		position = current_focus.position

#Change the target of the camera (between player and ball)
func change_focus(new_focus):
	update_amount_particle(nb_particles)
	current_focus = new_focus

func update_amount_particle(var new_amount: int):
	if (new_amount > nb_particles):
		$IncreaseParticles.emitting = true
		$IncreaseParticles.amount = new_amount
	else:
		$IncreaseParticles.emitting = false
