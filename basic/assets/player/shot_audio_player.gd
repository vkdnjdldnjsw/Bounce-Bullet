extends Spatial

# All of the audio files.
# You will need to provide your own sound files.
var audio_pistol_shot = preload("res://sounds/shot.wav")

var audio_node = null

func _ready():
    audio_node = $Audio_Stream_Player
    audio_node.connect("finished", self, "destroy_self")
    audio_node.stop()


func play_sound(sound_name, position=null):

    if audio_pistol_shot == null:
        print ("Audio not set!")
        queue_free()
        return

    if sound_name == "Pistol_shot":
        audio_node.stream = audio_pistol_shot
    else:
        print ("UNKNOWN STREAM")
        queue_free()
        return


    audio_node.play()


func destroy_self():
    audio_node.stop()
    queue_free()