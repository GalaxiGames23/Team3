extends KinematicBody2D

onready var anim_tree  = $AnimationTree
onready var anim_state = anim_tree.get("parameters/playback")

var Flag = preload("res://Flag/flag.tscn")
var Ball = preload("res://Ball/Ball.tscn")
var flag_instance : KinematicBody2D

var direction      : Vector2 = Vector2.ZERO
var velocity       : Vector2 = Vector2.ZERO
var last_velocity  : Vector2
var store_position : Vector2 = Vector2.ZERO
var base_scale: Vector2
var last_direction: Vector2
var freeze       : bool = false
var is_falling   : bool = false
var flag_dropped : bool = false
var respawn_position
var myCamera
var WallOnShoot : bool = false
var ball_instance

export var speed : float = 125.0
export var acceleration: float = 500
export var run_factor: float = 3

func _ready():
	
	anim_tree.active = true
	respawn_position = global_position
	base_scale = scale

func _physics_process(delta):
	
	if !freeze and !is_falling :
		last_velocity = velocity
		direction = get_input_velocity()
		if (Input.is_action_pressed("ui_run")):
			velocity = velocity.move_toward(direction * run_factor * speed, delta * acceleration*2.5) 
		else:
			velocity = velocity.move_toward(direction * speed, delta * acceleration) 
		if velocity.length() > speed/3 :
			_orientation(direction + 0.2 * velocity.move_toward(direction * speed,acceleration * delta * 5))
		velocity = move_and_slide(velocity,Vector2.UP)
		if (get_slide_count() and get_slide_collision(0).collider.name == "HoleMap"):
			start_falling(get_slide_collision(0).collider)
	elif is_falling:
		if (last_velocity.length() > 0.1):
			move_and_slide(last_velocity)
			last_velocity = last_velocity*(0.7+0.3*last_velocity.length()/(abs(last_velocity[0])+abs(last_velocity[1])))*0.98

	
		

#oriente le joueur correctement
func _orientation(dir):
	self.rotation=dir.angle()-PI/2

#retourne un Vecteur 2D indiquant la direction du personnage et l'oriente
func get_input_velocity() -> Vector2:
	var dir : Vector2 = Vector2.ZERO
	if (Input.is_action_pressed("ui_left") and !Input.is_action_pressed("ui_right")) or (!Input.is_action_pressed("ui_left") and Input.is_action_pressed("ui_right")) :
		dir.x = Input.get_action_strength("ui_right")-Input.get_action_strength("ui_left")
	if (Input.is_action_pressed("ui_up") and !Input.is_action_pressed("ui_down")) or (!Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_down")) :
		dir.y = Input.get_action_strength("ui_down")-Input.get_action_strength("ui_up")
	dir=dir.normalized()
	
	return dir

#fonction pour l'input
func _input(event):
	if event is InputEventKey and freeze==false and is_falling==false:
		#supprimer la liaison shoot->freeze dans le AnimationTree ne semble pas suffire, d'ou le freeze==false
		if Input.is_action_pressed("ui_shoot") :
			anim_state.travel("shoot")
		elif Input.is_action_pressed("ui_flag") and flag_dropped==false:
			store_position=position
			flag_dropped=true
			flag_instance=Flag.instance()
			flag_instance.position=position+Vector2(10,10)
			get_node("/root").add_child(flag_instance)
		elif Input.is_action_pressed("ui_tp") and flag_dropped==true :
			position=store_position
			store_position=Vector2.ZERO
			flag_dropped=false
			flag_instance.queue_free()

#Add a Ball to the scene, change the camera to the ball
func spawn_ball():
	assert(myCamera)
	print($SpawnBallPoint/NoWallOnShoot.get_overlapping_bodies())
	if ($SpawnBallPoint/NoWallOnShoot.get_overlapping_bodies().size()==0):
		ball_instance=Ball.instance()
		ball_instance.global_position = $SpawnBallPoint.global_position
		ball_instance.save_player = self
		ball_instance.spawn_direction = ($SpawnBallPoint.global_position - global_position).normalized()
		ball_instance.myCamera = myCamera
		get_node("/root").add_child(ball_instance)
		myCamera.change_focus(ball_instance)
		freeze = true
		velocity = Vector2.ZERO
	
		
		
#Player Start falling
func start_falling(hole):
	last_direction = direction
	is_falling = true
	set_collision_mask_bit(4,0)
	move_and_slide(last_velocity)
	anim_state.travel("fall")
	if (is_instance_valid(ball_instance)):
		ball_instance.queue_free()
		myCamera.change_focus(self)

#Respawn player to last checkpoint
func respawn_player():
	last_velocity = Vector2.ZERO
	velocity = Vector2.ZERO
	scale = base_scale
	_orientation(last_direction)
	global_position = respawn_position
	reset_all_interactible_object()
	if (flag_dropped):
		flag_dropped=false
		flag_instance.queue_free()

func unfreezePlayer():
	is_falling = false
	freeze = false
	velocity = Vector2.ZERO
func reset_all_interactible_object():
	var objects = get_tree().get_nodes_in_group("InterractibleObject")
	for obj in objects:
		obj.reset_objet()
#SMode End
func On_shoot_End():
	if (freeze):
		anim_state.travel("freeze")
	else:
		anim_state.travel("run")

func death():
	anim_state.travel("death")
	freeze = true
	if(is_instance_valid(ball_instance)):
		if (ball_instance.timer_is_finish()):
			ball_instance.start_fade_out()
			myCamera.change_focus(self)
	
	

#The ball touch anything, state = run
func On_Ball_Touch():
	freeze = false
	anim_state.travel("run")

