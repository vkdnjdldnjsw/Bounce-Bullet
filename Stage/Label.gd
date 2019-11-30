extends Label


var WORD_MAX_TIME = 1.5
var word_time = 0
var words = ["Press  W  A  S  D to Move" , "Move mouse to Aiming", "Press shift to Sprint", "Press left mouse to Fire " , "Press M to see map",  "Press R to retry"]
var word_num = 0
func _ready():
    pass

func _physics_process(delta):
    if word_time > 0:
        word_time -= delta
    if word_time <=0 && word_num < words.size():
        word_time = WORD_MAX_TIME
        text = words[word_num]
        word_num = word_num + 1
        
    if word_time <=0 && text != "" && word_num >= words.size():
        text = ""
        
