extends KinematicBody2D

onready var anim_tree  = $AnimationTree
onready var anim_state = anim_tree.get("parameters/playback")

var Flag = preload("res://Flag/flag.tscn")

var flag_instance : KinematicBody2D

var direction      : Vector2 = Vector2.ZERO
var velocity       : Vector2 = Vector2.ZERO
var store_position : Vector2 = Vector2.ZERO

var freeze       : bool = false
var flag_dropped : bool = false

export var speed : float = 125.0

func _ready():
	anim_tree.active = true

func _physics_process(delta):
	if freeze == false :
		direction = get_input_velocity()
		if (Input.is_action_pressed("ui_run")):
			velocity = direction * 3 * speed
		else:
			velocity = direction * speed
		move_and_slide(velocity,Vector2.UP)

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
	if dir != Vector2.ZERO:
		_orientation(dir)
	return dir

#fonction pour l'input
func _input(event):
	if event is InputEventKey and freeze==false:
		#supprimer la liaison shoot->freeze dans le AnimationTree ne semble pas suffire, d'ou le freeze==false
		if Input.is_action_pressed("ui_shoot") :
			anim_state.travel("shoot")
			#print_debug("SHOOOOT",randi())
		elif Input.is_action_pressed("ui_flag") and flag_dropped==false:
			store_position=position
			flag_dropped=true
			flag_instance=Flag.instance()
			flag_instance.position=position+Vector2(100,100)
			get_node("/root").add_child(flag_instance)
		elif Input.is_action_pressed("ui_tp") and flag_dropped==true :
			position=store_position
			store_position=Vector2.ZERO
			flag_dropped=false
			flag_instance.queue_free()

func On_shoot_End():
	freeze = true
	anim_state.travel("freeze")
