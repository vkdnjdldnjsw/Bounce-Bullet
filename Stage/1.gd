extends Spatial


func _ready():
    pass 

func _physics_process(delta):
    if $Player.is_dead == true && $Label.text != "":
        $Label.text = ""
        $Label.word_num = $Label.words.size()