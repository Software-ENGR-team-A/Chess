# GdUnit generated TestSuite
class_name AudioManagerTest
extends GdUnitTestSuite
@warning_ignore("unused_parameter")
@warning_ignore("return_value_discarded")
# TestSuite generated from
const AUDIO_MANAGER := preload("res://scenes/sound_system/audio_manager.gd")


func new_audiomanager(manager_name: String) -> Node:
	var am: Node = AUDIO_MANAGER.new()
	am.bus_name = manager_name
	add_child(am)
	return am


func test_init() -> void:
	var manager := new_audiomanager("Master")
	var expected: int = AudioServer.get_bus_index("Master")
	assert_that(expected).is_greater_equal(0)
	assert_that(manager.sfx_bus_idx).is_equal(expected)
	manager.queue_free()


func test_missing_bus() -> void:
	# Verify the bus does not exist
	var manager := new_audiomanager("__NO_SUCH_BUS__")
	var manager_idx: int = manager.sfx_bus_idx
	assert_that(manager_idx).is_equal(-1)

	# Verify the volume cannot be changed
	var volume: float = manager.get_volume()
	manager.set_volume(-5)
	assert_that(volume).is_equal(-1000.0)
	manager.queue_free()


func test_volume() -> void:
	var manager := new_audiomanager("Master")
	var expected_volume: float = -1.5
	manager.set_volume(expected_volume)
	var volume: float = manager.get_volume()

	assert_that(volume).is_equal(expected_volume)
	manager.queue_free()


func test_play_sound() -> void:
	var manager := new_audiomanager("Master")
	var stream := AudioStreamGenerator.new()  # Create a dummy stream
	var expected_vol := -5.0

	manager.play_sound(stream, expected_vol)

	assert_that(manager.get_child_count()).is_equal(1)

	var player: AudioStreamPlayer = manager.get_child(0)
	assert_that(player.stream).is_equal(stream)
	assert_that(player.volume_db).is_equal(expected_vol)
	assert_that(player.bus).is_equal("Master")
	assert_that(player.playing).is_true()

	manager.queue_free()


func test_play_sound_null_stream() -> void:
	var manager := new_audiomanager("Master")

	# Attempt to play null
	manager.play_sound(null)

	# Verify no child player was created (safely returned early)
	assert_that(manager.get_child_count()).is_equal(0)

	manager.queue_free()


func test_play_sound_cleanup_connection() -> void:
	var manager := new_audiomanager("Master")
	var stream := AudioStreamGenerator.new()

	manager.play_sound(stream)

	var player: AudioStreamPlayer = manager.get_child(0)

	# Verify the 'finished' signal is connected to 'queue_free'
	# This ensures the node destroys itself when the sound ends
	assert_that(player.finished.is_connected(player.queue_free)).is_true()
	manager.queue_free()
