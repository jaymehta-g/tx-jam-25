extends BaseTrap

@onready
var static_body_collider := $StaticBody2D/CollisionShape2D

func _ready() -> void:
    activated.connect(func():
        static_body_collider.disabled = false
    )
    deadly = false
    super._ready()