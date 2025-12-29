extends Node2D
class_name FullscreenToggle

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("fullscreen_toggle"):
        var mode = DisplayServer.window_get_mode()
        match mode:
            DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN, DisplayServer.WINDOW_MODE_FULLSCREEN: 
                DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
            _:   
                DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
#
#func _get_property_list():
    #var actions = []
    #for prop in ProjectSettings.get_property_list():
        #var prop_name:String = prop.get("name", "")
        #if prop_name.begins_with('input/'):
            #prop_name = prop_name.replace('input/', '') 
            #prop_name = prop_name.substr(0, prop_name.find("."))
            #if not actions.has(prop_name):
                #actions.append(prop_name)
    #
    #var hint_string = ",".join(actions)
    #
    #var properties = []
    #properties.append({
        #"name": "prompt_action",
        #"type": TYPE_STRING_NAME,
        #"hint": PROPERTY_HINT_ENUM,
        #"hint_string": hint_string
    #})
    #return properties
