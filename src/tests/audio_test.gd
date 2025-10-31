class_name AudioManagerTest
extends GdUnitTestSuite
@warning_ignore("unused_parameter")
@warning_ignore("return_value_discarded")

const AM_SCRIPT := preload("res://scenes/sound_system/audio_manager.gd")

func _new_am(bus_name: String) -> Node:
	var am: Node = AM_SCRIPT.new()
	am.bus_name = bus_name
	am._ready()
	return am

func test_ready_sets_bus_index_on_master() -> void:
	var am := _new_am("Master")
	var expected: int = AudioServer.get_bus_index("Master")
	assert_that(expected).is_greater_equal(0)
	assert_that(am.sfx_bus_idx).is_equal(expected)
	am.queue_free()

func test_get_volume_returns_minus_1000_when_bus_missing() -> void:
	var am := _new_am("__NO_SUCH_BUS__")
	var vol: float = am.get_volume()
	assert_that(vol).is_equal(-1000.0)
	am.queue_free()

func test_set_volume_noop_when_bus_missing() -> void:
	var am := _new_am("__NO_SUCH_BUS__")
	am.set_volume(-12.0)
	var vol: float = am.get_volume()
	assert_that(vol).is_equal(-1000.0)
	am.queue_free()

func test_set_volume_updates_master_and_restores_value() -> void:
	var am := _new_am("Master")
	var idx: int = AudioServer.get_bus_index("Master")
	var original: float = AudioServer.get_bus_volume_db(idx)
	var target: float = clamp(original - 6.0, -80.0, 24.0)

	am.set_volume(target)
	var new_db: float = AudioServer.get_bus_volume_db(idx)
	assert_that(new_db).is_equal(target)  # no with_delta

	# restore and cleanup
	am.set_volume(original)
	am.queue_free()
