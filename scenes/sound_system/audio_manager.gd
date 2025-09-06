extends Node


# MOVEMENT SOUNDS
func play_pickup():
	$Movement/Pickup.play()


func play_place():
	$Movement/Place.play()


func play_capture():
	$Movement/Capture.play()


func play_invalid():
	$Movement/Invalid.play()


func play_check():
	$Movement/Check.play()


func play_checkmate():
	$Movement/Checkmate.play()


func play_stalemate():
	$Movement/Stalemate.play()


# MENU SOUNDS
func play_openmenu():
	$Menu/Open.play()


func play_closemenu():
	$Menu/Close.play()


func play_selectmenu():
	$Menu/Select.play()
