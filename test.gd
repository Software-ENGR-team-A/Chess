extends Node

func test_Set_setting():
	var manager = preload("res://SettingsManager.gd").new()
	
	# Test setting a new value
	manager.Set_setting("volume", 75)
	assert(manager.Get_setting("volume") == 75, "Volume should be set to 75")
	
	# Test updating existing value
	manager.Set_setting("volume", 50)
	assert(manager.Get_setting("volume") == 50, "Volume should be updated to 50")
	
	# Test setting a different setting
	manager.Set_setting("brightness", 100)
	assert(manager.Get_setting("brightness") == 100, "Brightness should be set to 100")
	
	# Test setting with empty string key (edge case)
	manager.Set_setting("", "empty_key_value")
	assert(manager.Get_setting("") == "empty_key_value", "Empty string key should store the value")
	
	print("All Set_setting tests passed!")
