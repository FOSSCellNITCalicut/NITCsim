extends Node2D



func _on_academic_building_body_entered(body):
	print("area enterd")
	
	body.show_interact_label()
	pass # Replace with function body.


func _on_academic_building_body_exited(body):
	print("Area exited")
	
	body.hide_interact_label()
	pass # Replace with function body.
