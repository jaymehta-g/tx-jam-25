class_name ItemDisplaySpace

extends MarginContainer

@export var possible_traps: Array[TrapInfo]

@onready var filled_item_display: PanelContainer = %"Filled Item Display"
@onready var item_texture_rect: TextureRect = %ItemTextureRect
@onready var price_label: Label = %PriceLabel
@onready var new_item_progress: TextureProgressBar = %"New Item Progress"

@onready var refresh_timer: Timer = $RefreshTimer

var held_trap: TrapInfo:
	set(v):
		held_trap = v
		filled_item_display.modulate.a = 1 if v else 0
		new_item_progress.modulate.a = 0 if v else 1

var disabled := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	refresh_timer.timeout.connect(refill_space)
	SignalBus.trap_picked.connect(func(_type): disabled = true)
	SignalBus.trap_placed.connect(func(): disabled = false)
	
	refill_space()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	new_item_progress.value = 1.0 - (refresh_timer.time_left / refresh_timer.wait_time)

# TODO prevent the display from doing anything if trapper cant afford it
func _gui_input(event: InputEvent) -> void:
	if disabled: return
	if not refresh_timer.is_stopped(): return
	if not event is InputEventMouseButton: return
	var mouse_event := event as InputEventMouseButton
	if mouse_event.button_index != 1 or not mouse_event.pressed: return
	
	refresh_timer.start()
	SignalBus.trap_picked.emit(held_trap)
	
	held_trap = null

func refill_space():
	var new_trap := possible_traps.pick_random() as TrapInfo
	item_texture_rect.texture = new_trap.sprite
	price_label.text = str(new_trap.cost)
	
	held_trap = new_trap
	pass
