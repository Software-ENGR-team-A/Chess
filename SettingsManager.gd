extends Node

var settings = {}


func Set_setting(setting: String, value):
	settings[setting] = value


func Get_setting(setting: String):
	return settings.get(setting, null)
