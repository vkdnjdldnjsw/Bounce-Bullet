extends Control

func _ready():
    $Margin_Container/Story_Menu/Button_back.connect("pressed", self, "ending_close", [])
    $Margin_Container/Story_Menu/Button_back_to_main.connect("pressed", self, "go_to_main", [])
func ending_close():
    visible = false
    get_parent().show_off_ending()
func go_to_main():
    visible = false
    get_tree().change_scene("res://Main_menu/MainMenu2.tscn")
