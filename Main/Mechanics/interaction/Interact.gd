extends Node2D



func _on_academic_building_body_entered(body : Player):
	print("Area entered")
	
	body.show_interact_label()
	pass # Replace with function body.


func _on_academic_building_body_exited(body : Player):
	print("Area exited")
	
	body.hide_interact_label()
	pass # Replace with function body.
