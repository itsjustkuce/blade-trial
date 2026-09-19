extends Area2D

signal defeated

@export var health: int = 2

func _ready() -> void:
	add_to_group("enemies")

func take_damage(amount: int) -> void:
	health -= amount

	if health <= 0:
		defeated.emit()
		queue_free()
	else:
		var slime_sprite := get_node_or_null("SlimeSprite") as Sprite2D
		
		if slime_sprite:
			slime_sprite.modulate = Color(1.0, 0.3, 0.3)
		else:
			push_warning("%s is missing a SlimeSprite child." % name)
