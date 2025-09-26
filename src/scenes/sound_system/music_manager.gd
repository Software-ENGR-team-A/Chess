extends Node

@export var bus_name: String = "Music"  # The Audio Bus name
@export var history_size: int = 3  # How large the shuffle history should be
@export var music_library: MusicLibrary  # The resource containing the music arrays

var recently_played: Array[AudioStream] = []  # The shuffle, recently played list
var current_playlist: Array[AudioStream] = []  # The currently loaded playlist
var music_bus_idx: int  # The audio bus index (loaded in _ready)
var audio_player: AudioStreamPlayer  # The audio player (instanced in _ready)


func _ready() -> void:
	audio_player = AudioStreamPlayer.new()  # Create the audioPlayer
	add_child(audio_player)  # Attach it to the node
	audio_player.finished.connect(_on_music_player_finished)  # Connect the signal

	music_bus_idx = AudioServer.get_bus_index(bus_name)  # Set the bus index var
	audio_player.bus = bus_name  # set the name of the audio player
	if music_library:  # If the library exists, play the menu music on launch
		play_playlist(music_library.gameplay_tracks)


## Plays the selected playlist through the Music Bus
## [param new_playlist] is a playlist from [MusicLibrary]
func play_playlist(new_playlist: Array[AudioStream]) -> void:
	if not music_library:  # Is there a library?
		printerr("MusicManager: Library not found")
		return
	if new_playlist.is_empty():  # Are there tracks to play?
		printerr("MusicManager:" + str(new_playlist) + "is empty")
		return
	if new_playlist == current_playlist:
		printerr("MusicManager: Attempted to play the same playlist.")
		return

	current_playlist = new_playlist
	recently_played.clear()
	play_random_song()


## Plays a random song from the playlist, ending the
## current song in the process.
func play_random_song() -> void:
	if current_playlist.is_empty():  #If there are no songs, don't try
		return

	var available_songs: Array[AudioStream] = []  # Songs that are chosen from
	for song in current_playlist:
		if not recently_played.has(song):  # If the osong has not recently been played
			available_songs.append(song)  # add it to the available_songs array

	if available_songs.is_empty():  # If there are no songs left
		recently_played.clear()  # Clear the recently played array
		available_songs = current_playlist.duplicate()  # and add all songs to the available array

	var max_history = clamp(history_size, 0, current_playlist.size() - 1)
	var next_song: AudioStream = available_songs.pick_random()  # Pick a song at random

	# SPIN THE RECORD BAYBEEEEEE
	audio_player.stop()
	audio_player.stream = next_song
	audio_player.play()

	recently_played.push_back(next_song)  # Add the played song to the recent queue

	if recently_played.size() > max_history:  #if the queue is too large
		recently_played.pop_front()  # take the oldest song out


## Stops the current playing song
func stop_music() -> void:
	audio_player.stop()


## Sets the [member volume_db] property of the Music bus
## [param vol_db] The dB volume level desired
func set_volume(vol_db: float) -> void:
	if music_bus_idx == -1:  # If the bus is not found, give an error
		printerr("MusicManager: Audio bus '", bus_name, "' not found. Could not set volume.")
		return
	# Otherwise set the volume
	AudioServer.set_bus_volume_db(music_bus_idx, vol_db)


## Returns the current music bus volume
## Returns -1000 if the bus is not found
func get_volume() -> float:
	if music_bus_idx == -1:  # If the bus is not found, give an error
		printerr("MusicManager: Audio bus '", bus_name, "' not found. Could not set volume.")
		return -1000
	return AudioServer.get_bus_volume_db(music_bus_idx)


## This is run whenever the current song ends
func _on_music_player_finished() -> void:  # When the song is over, play another random one
	play_random_song()
