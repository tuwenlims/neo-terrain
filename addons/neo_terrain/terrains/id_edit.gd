@tool
extends LineEdit

var regex = RegEx.new()
var old_text = ""

func _ready():
	regex.compile("^[a-zA-Z0-9_-]*$")

func _on_text_changed(new_text: String):
	if regex.search(new_text):
		old_text = new_text
	else:
		var current_caret = caret_column
		text = old_text
		caret_column = current_caret - 1 
