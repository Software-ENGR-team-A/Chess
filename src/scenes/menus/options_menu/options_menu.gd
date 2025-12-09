# res://scenes/menus/options_menu/options_menu.gd

class_name OptionsMenu
extends Control

# dB range for all three sliders
const MIN_DB := -80.0  # near silent
const MAX_DB := 5.0  # full volume
const DEFAULT_DB := -20.0

# Bus names – CHANGE THESE if your buses are named differently
const MUSIC_BUS := "Music"
const SFX_BUS := "Sound Effects"
const MASTER_BUS := "Master"

@export var music_slider: HSlider
@export var sfx_slider: HSlider
@export var master_slider: HSlider
@export var back_button: Button


func _ready() -> void:
	# Init sliders from current bus values
	_init_slider_for_bus(music_slider, MUSIC_BUS)
	_init_slider_for_bus(sfx_slider, SFX_BUS)
	_init_slider_for_bus(master_slider, MASTER_BUS)

	# Wire up callbacks
	if music_slider:
		music_slider.value_changed.connect(func(v: float) -> void: _set_bus_db(MUSIC_BUS, v))

	if sfx_slider:
		sfx_slider.value_changed.connect(func(v: float) -> void: _set_bus_db(SFX_BUS, v))

	if master_slider:
		master_slider.value_changed.connect(func(v: float) -> void: _set_bus_db(MASTER_BUS, v))

	if back_button:
		back_button.pressed.connect(_on_back_pressed)


# --- Helpers --------------------------------------------------------


func _init_slider_for_bus(slider: HSlider, bus_name: String) -> void:
	if not slider:
		return

	slider.min_value = MIN_DB
	slider.max_value = MAX_DB
	slider.step = 1.0

	var current_db := _get_bus_db(bus_name)
	if is_nan(current_db):
		current_db = DEFAULT_DB

	slider.value = clamp(current_db, MIN_DB, MAX_DB)


func _get_bus_db(bus_name: String) -> float:
	var bus := AudioServer.get_bus_index(bus_name)
	if bus == -1:
		# Bus not found – fail gracefully
		return NAN
	return AudioServer.get_bus_volume_db(bus)


func _set_bus_db(bus_name: String, db: float) -> void:
	var bus := AudioServer.get_bus_index(bus_name)
	if bus == -1:
		return
	AudioServer.set_bus_volume_db(bus, clamp(db, MIN_DB, MAX_DB))


func _on_back_pressed() -> void:
	queue_free()
