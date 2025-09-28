extends BaseTrap

@onready var rm_timer := $"Remove Timer"

func _ready() -> void:
    activated.connect(rm_timer.start)
    rm_timer.timeout.connect(queue_free)
    super._ready()