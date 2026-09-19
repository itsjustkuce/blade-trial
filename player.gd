extends CharacterBody2D

@export var speed: float = 150.0

@onready var sword_pivot: Node2D = $SwordPivot
@onready var sword_visual: ColorRect = $SwordPivot/SwordVisual
@onready var sword_hitbox: Area2D = $SwordPivot/SwordHitbox
@onready var attack_timer: Timer = $AttackTimer

var facing := Vector2.RIGHT
var attacking := false


func _ready() -> void:
	sword_visual.z_index = 10
	sword_visual.visible = false
	sword_hitbox.monitoring = false
	attack_timer.one_shot = true
	attack_timer.timeout.connect(_on_attack_timer_timeout)
	sword_hitbox.area_entered.connect(_on_sword_hitbox_area_entered)


func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector(
		"ui_left",
		"ui_right",
		"ui_up",
		"ui_down"
	)

	if direction != Vector2.ZERO:
		facing = direction.normalized()
		sword_pivot.rotation = facing.angle()

	if attacking:
		velocity = Vector2.ZERO
	else:
		velocity = direction * speed

	move_and_slide()

	if Input.is_action_just_pressed("ui_accept") and not attacking:
		attack()


func attack() -> void:
	attacking = true
	sword_visual.show()
	sword_hitbox.monitoring = true
	attack_timer.start(0.5)


func _on_attack_timer_timeout() -> void:
	attacking = false
	sword_visual.hide()
	sword_hitbox.monitoring = false

func _on_sword_hitbox_area_entered(area: Area2D) -> void:
	if area.has_method("take_damage"):
		area.take_damage(1)
