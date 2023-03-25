extends KinematicBody2D


export var speed = 100
export var speed_to_break_wall_hard = 350
export var velocity = Vector2.ZERO
export var direction = Vector2.ZERO
export var last_position = Vector2.ZERO

export var can_break_wall_hard = false
export var can_break_wall_soft = true
var spawn_direction
var save_player
var myCamera
var ballwilldisapear = false

# Called when the node enters the scene tree for the first time.
func _ready():
	direction = spawn_direction
	$Hitbox.disabled = false



func _physics_process(delta):
	if ((not can_break_wall_hard) and (speed >= speed_to_break_wall_hard) and !ballwilldisapear):
		can_break_wall_hard = true
		can_break_wall_soft = false
		myCamera.update_amount_particle(100)
		$AnimationPlayer.play("CanBreakSpeedAnim")
	if (direction != Vector2.ZERO):
		speed += 1
	direction = get_direction()
	velocity = direction * speed
	rotation_degrees += speed * delta
	if (velocity != Vector2.ZERO):
		var new_velocity = move_and_slide(velocity,Vector2.UP)
		#if (new_velocity != velocity): #Je sais pas ce que ça faisait mais ça marche sans
		#	velocity = new_velocity
		#	speed = velocity.length()
		#	direction = velocity.normalized()
		var obstacle_array = get_slide_count()
		
		if (obstacle_array):
			if (get_slide_collision(0).collider.is_in_group("Player")):
				start_fade_out()
				$Hitbox.disabled = true
				save_player.death()
			elif (get_slide_collision(0).collider.name == "WallThatBreakTheBall"):
				myCamera.change_focus(save_player)
				save_player.freeze = false
				queue_free()
			elif (get_slide_collision(0).collider.name == "WallThatBounce"):
				if(is_on_wall()):
					direction.x = -1*direction.x
					velocity.x = -1*velocity.x
				if(is_on_floor() or is_on_ceiling()):
					direction.y = -1*direction.y
					velocity.y = -1*velocity.y
			else:
				print(get_slide_collision(0).collider.name== "WallThatBreakTheBall")
				teleport_player()
			

#Teleport the player to the ball position
func teleport_player():
	save_player.global_position = global_position
	save_player.On_Ball_Touch()
	save_player._orientation(velocity)
	myCamera.change_focus(save_player)
	queue_free()

func break_a_wall_anim_for_cam():
	myCamera.play_hearthquake()
"""
Récupère l'input du joueur et fait tendre la direction de la balle vers la direction 
donnée par le joueur (rapproche de 10% par tick).
"""
func get_direction() -> Vector2:
	var input_dir = Vector2.ZERO
	var ret_dir = Vector2.ZERO
	input_dir.x = Input.get_action_strength("ui_right")-Input.get_action_strength("ui_left")
	input_dir.y = Input.get_action_strength("ui_down")-Input.get_action_strength("ui_up")
	if (direction == Vector2.ZERO):
		ret_dir = input_dir
	elif (direction.angle() == input_dir.angle() + PI):
		ret_dir = Vector2(direction.x+1, direction.y)
	else:
		ret_dir = (direction*9 + input_dir)/10
	return ret_dir.normalized()
	
func start_fade_out():
	$AnimationPlayer.play("BallFadeOut")
	myCamera.change_focus(save_player)		


func _on_KillPlayerTimer_timeout():
	queue_free()

func timer_is_finish():
	return $AnimationPlayer.current_animation != "BallFadeOut"
	
func ball_disapear():
	ballwilldisapear = true
