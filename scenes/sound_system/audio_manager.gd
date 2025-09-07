extends Node

@export var bus_name: String = "Sound Effects"

@export var movement: MovementSounds
@export var menu: MenuSounds

var sfx_bus_idx: int


func _ready():
	sfx_bus_idx = AudioServer.get_bus_index(bus_name)


func play_sound(stream: AudioStream, volume_db: float = 0.0) -> void:
	if not stream:
		printerr("Attempted to play a null audio stream.")
		return

	var player = AudioStreamPlayer.new()

	player.stream = stream
	player.volume_db = volume_db
	player.bus = bus_name

	add_child(player)
	player.play()

	player.finished.connect(player.queue_free)


func set_volume(vol_db: float) -> void:
	if sfx_bus_idx == -1:  # If the bus is not found, give an error
		printerr("Audio bus '", bus_name, "' not found. Could not set volume.")
		return
	# Otherwise set the volume
	AudioServer.set_bus_volume_db(sfx_bus_idx, vol_db)


func get_volume() -> float:
	if sfx_bus_idx == -1:  # If the bus is not found, give an error
		printerr("Audio bus '", bus_name, "' not found. Could not set volume.")
		return -1000
	return AudioServer.get_bus_volume_db(sfx_bus_idx)
