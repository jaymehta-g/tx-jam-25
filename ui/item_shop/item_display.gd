class_name ItemDisplaySpace

extends MarginContainer

@onready var filled_item_display: PanelContainer = %"Filled Item Display"
@onready var item_texture_rect: TextureRect = %ItemTextureRect
@onready var price_label: Label = %PriceLabel
@onready var new_item_progress: TextureProgressBar = %"New Item Progress"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
