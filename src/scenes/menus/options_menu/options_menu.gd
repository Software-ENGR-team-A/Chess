# res://scenes/menus/options_menu/options_menu.gd

class_name OptionsMenu
extends Control

@export var music_slider: HSlider
@export var back_button: Button

const MIN_VOLUME := -60
const MAX_VOLUME := 5
const DEFAULT_VOLUME := -15


func _ready() -> void:
	_init_music_slider()

	if back_button:
		back_button.pressed.connect(_on_back_pressed)

	if music_slider:
		music_slider.value_changed.connect(_on_music_slider_value_changed)


func _init_music_slider() -> void:
	if not music_slider:
		return

	music_slider.min_value = MIN_VOLUME
	music_slider.max_value = MAX_VOLUME
	music_slider.step = 0.1

	var current_volume := DEFAULT_VOLUME
	if MusicManager.has_method("get_volume"):
		current_volume = float(MusicManager.get_volume())

	music_slider.value = clamp(current_volume, MIN_VOLUME, MAX_VOLUME)


func _on_music_slider_value_changed(value: float) -> void:
	if MusicManager.has_method("set_volume"):
		MusicManager.set_volume(value)


func _on_back_pressed() -> void:
	queue_free()
