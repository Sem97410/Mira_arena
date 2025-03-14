extends Node

@export var max_simultaneous_steps = 3  # Nombre max de sons simultanés
var step_sounds_playing = 0  # Compteur des sons actifs

func request_footstep(slime: Node3D) -> void :
	#print("Launch request footstep")
	if step_sounds_playing >= max_simultaneous_steps:
		return  # Trop de sons en même temps, ignore la demande

	var footstep_audio = slime.get_node_or_null("FootStepAudioPlayer")
	if footstep_audio and not footstep_audio.playing:
		step_sounds_playing += 1
		footstep_audio.play()
		await footstep_audio.finished
		step_sounds_playing -= 1
