extends Node


# MOVEMENT SOUNDS
func play_pickup() -> void:
	$Movement/Pickup.play()


func play_place() -> void:
	$Movement/Place.play()


func play_capture() -> void:
	$Movement/Capture.play()


func play_invalid() -> void:
	$Movement/Invalid.play()


func play_check() -> void:
	$Movement/Check.play()


func play_checkmate() -> void:
	$Movement/Checkmate.play()


func play_stalemate() -> void:
	$Movement/Stalemate.play()


# MENU SOUNDS
func play_openmenu() -> void:
	$Menu/Open.play()


func play_closemenu() -> void:
	$Menu/Close.play()


func play_selectmenu() -> void:
	$Menu/Select.play()
