extends StaticBody2D

@export var sprite_region := Rect2(496, 192, 48, 32)
@export var collision_size := Vector2(44, 18)
@export var collision_offset := Vector2(0, 10)


func _ready() -> void:
	var sprite: Sprite2D = $Sprite2D
	sprite.region_enabled = true
	sprite.region_rect = sprite_region
	var shape: RectangleShape2D = $CollisionShape2D.shape
	shape.size = collision_size
	$CollisionShape2D.position = collision_offset
