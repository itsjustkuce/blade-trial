extends Node2D

var enemies_left: int = 0
var won := false

@onready var status_label: Label = $CanvasLayer/StatusLabel
@onready var exit_sprite: Sprite2D = $Exit/ExitSprite
@onready var player: CharacterBody2D = $Player
@onready var exit_area: Area2D = $Exit


func _ready() -> void:
	var enemies := get_tree().get_nodes_in_group("enemies")
	enemies_left = enemies.size()

	for enemy in enemies:
		enemy.defeated.connect(_on_enemy_defeated)

	exit_area.body_entered.connect(_on_exit_body_entered)
	exit_sprite.modulate = Color(0.6, 0.25, 0.25)
	update_status()


func _on_enemy_defeated() -> void:
	enemies_left -= 1

	if enemies_left <= 0:
		enemies_left = 0
		status_label.text = "Exit unlocked!"
		exit_sprite.modulate = Color(0.4, 1.0, 0.4)
	else:
		update_status()


func _on_exit_body_entered(body: Node2D) -> void:
	if body == player and enemies_left <= 0 and not won:
		won = true
		player.set_physics_process(false)
		status_label.text = "VICTORY! Press R to restart."


func _unhandled_input(event: InputEvent) -> void:
	if won and event is InputEventKey:
		if event.pressed and event.keycode == KEY_R:
			get_tree().reload_current_scene()


func update_status() -> void:
	status_label.text = "Slimes remaining: %d" % enemies_left
