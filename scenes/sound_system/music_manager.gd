extends Node

const SHUFFLE_LIMIT = 4  #How many times it will try to prevent the same song from playing

@export var songs: Array[AudioStream]

var prev_song  # The previous song played
var next_song  # The next/current song played

@onready var audio_player: AudioStreamPlayer = $MusicPlayer


func play_random_song():
	var shuffle_count = 0  # Temp variable for shuffle retries
	if songs.is_empty():  #If there are no songs, don't try
		return

	audio_player.stop()  # Stop the current song
	next_song = songs.pick_random()  #pick a random one

	# If the random song is the same song, try again up to SHUFFLE_LIMIT times
	while (next_song == prev_song) & (shuffle_count <= SHUFFLE_LIMIT):
		next_song = songs.pick_random()
		shuffle_count += 1

	prev_song = next_song  # Change the stored previous song
	audio_player.stream = next_song  # Set the next song in the player

	audio_player.play()  # SPIN THE RECORD BAYBEEEEEE


func stop_music():
	audio_player.stop()


func set_volume(vol_db: float):
	audio_player.volume_db = vol_db
