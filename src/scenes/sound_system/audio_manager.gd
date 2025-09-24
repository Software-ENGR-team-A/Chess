extends Node

@export var bus_name: String = "Sound Effects"

@export var movement: MovementSounds
@export var menu: MenuSounds

var sfx_bus_idx: int


func _ready():
	sfx_bus_idx = AudioServer.get_bus_index(bus_name)


## Plays the desired sound effect from the [MenuSounds] or [MovementSounds]
## Resource file
## [param stream] Is the audiostream from the resource
## [param volume_db] is the dB level for the audioStream
func play_sound(stream: AudioStream, volume_db: float = 0.0) -> void:
	if not stream:
		printerr("AudioManager: Attempted to play a null audio stream.")
		return

	var player = AudioStreamPlayer.new()

	player.stream = stream
	player.volume_db = volume_db
	player.bus = bus_name

	add_child(player)
	player.play()

	player.finished.connect(player.queue_free)


## Sets the [member volume_db] property of the SFX bus
## [param vol_db] The dB volume level desired
func set_volume(vol_db: float) -> void:
	if sfx_bus_idx == -1:  # If the bus is not found, give an error
		printerr("AudioManager: Audio bus '", bus_name, "' not found. Could not set volume.")
		return
	# Otherwise set the volume
	AudioServer.set_bus_volume_db(sfx_bus_idx, vol_db)


## Returns the current SFX bus volume
## Returns -1000 if the bus is not found
func get_volume() -> float:
	if sfx_bus_idx == -1:  # If the bus is not found, give an error
		printerr("AudioManager: Audio bus '", bus_name, "' not found. Could not set volume.")
		return -1000
	return AudioServer.get_bus_volume_db(sfx_bus_idx)
