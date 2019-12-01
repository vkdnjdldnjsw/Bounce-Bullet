extends Spatial

var square_rotate
var hexa_rotate
var octa_rotate
var deca_rotate

var square
var hexa
var octa
var deca

var MAX_CHANGE_TIME = 3
var change_time = 0

func _ready():
    square = $square
    hexa = $hexa
    octa = $octa
    deca = $deca
    change_time = 0

func _physics_process(delta):
    change_time -= delta
    
    if change_time <= 0:
        change_time = MAX_CHANGE_TIME
        square_rotate = 0.4 + randf() / 10
        hexa_rotate = 0.3 + randf()  / 10
        octa_rotate = 0.2 + randf() / 10
        deca_rotate = 0.1 + randf() / 10
        if randf() > 0.5:
            square_rotate *= -1
        if randf() > 0.5:
            hexa_rotate *= -1
        if randf() > 0.5:
            octa_rotate *= -1
        if randf() > 0.5:
            deca_rotate *= -1
    
    for wall in square.get_children():
        wall.rotate_object_local(Vector3(0,1,0), float(deg2rad(square_rotate)))
    for wall in hexa.get_children():
        wall.rotate_object_local(Vector3(0,1,0), float(deg2rad(hexa_rotate)))
    for wall in octa.get_children():
        wall.rotate_object_local(Vector3(0,1,0), float(deg2rad(octa_rotate)))
    for wall in deca.get_children():
        wall.rotate_object_local(Vector3(0,1,0), float(deg2rad(deca_rotate)))
func show_ending():
    $Ending.visible = true
    Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
    $Player.setEscapePoseMode(Node.PAUSE_MODE_STOP)
func show_off_ending():
    Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
    $Ending.visible = false
    $Player.setEscapePoseMode(Node.PAUSE_MODE_PROCESS)
    
