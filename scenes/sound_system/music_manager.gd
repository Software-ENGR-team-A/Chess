extends Node

@export var history_size: int = 4
@export var songs: Array[AudioStream]

var recently_played: Array[AudioStream] = []

@onready var audio_player: AudioStreamPlayer = $MusicPlayer


func _ready() -> void:
	if not songs.is_empty():
		history_size = clamp(history_size, 0, songs.size() - 1)


func play_random_song() -> void:
	if songs.is_empty():  #If there are no songs, don't try
		return

	var available_songs: Array[AudioStream] = []  # Songs that are chosen from
	for song in songs:
		if not recently_played.has(song):  # If the osong has not recently been played
			available_songs.append(song)  # add it to the available_songs array

	if available_songs.is_empty():  # If there are no songs left
		recently_played.clear()  # Clear the recently played array
		available_songs = songs.duplicate()  # and add all songs to the available array

	var next_song: AudioStream = available_songs.pick_random()  # Pick a song at random

	# SPIN THE RECORD BAYBEEEEEE
	audio_player.stop()
	audio_player.stream = next_song
	audio_player.play()

	recently_played.push_back(next_song)  # Add the played song to the recent queue

	if recently_played.size() > history_size:  #if the queue is too large
		recently_played.pop_front()  # take the oldest song out


func stop_music() -> void:
	audio_player.stop()


func set_volume(vol_db: float) -> void:
	audio_player.volume_db = vol_db


func _on_music_player_finished() -> void:  # When the song is over, play another random one
	play_random_song()
