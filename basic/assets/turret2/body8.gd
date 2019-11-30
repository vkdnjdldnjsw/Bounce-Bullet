extends RigidBody

func _ready():
    pass

func bullet_hit(damage, bullet_hit_pos):
    mode = RigidBody.MODE_RIGID

func getObjectName():
    return "Turret"