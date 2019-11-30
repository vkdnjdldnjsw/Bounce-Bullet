extends Spatial

func _ready():
    get_tree().paused = false
    $KinematicBody.isMainMenu = true
    $KinematicBody.BULLET_SPEED = 30
    $KinematicBody._go(Vector3(randf(), randf(), randf()).normalized())
    $CheckButton.connect("pressed", self,  "setSound" , [])

func setSound():
    $KinematicBody.sound = !$KinematicBody.sound