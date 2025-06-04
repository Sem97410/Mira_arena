extends Node

var number_of_maps: int = 2
var last_scores: Dictionary = {}
var max_scores: Dictionary = {}

var save_folder_path := "user://Cry Again Games"
var save_file_path := save_folder_path + "/score_data.save"

func _ready() -> void:
	ensure_save_folder_exists()
	load_data()

func ensure_save_folder_exists():
	if not DirAccess.dir_exists_absolute(save_folder_path):
		var err := DirAccess.make_dir_recursive_absolute(save_folder_path)
		if err != OK:
			push_error("❌ Échec création dossier de sauvegarde : " + save_folder_path)

func save():
	var file := FileAccess.open(save_file_path, FileAccess.WRITE)
	if file:
		file.store_var(last_scores)
		file.store_var(max_scores)
	else:
		push_error("❌ Impossible d'écrire dans : " + save_file_path)

func load_data():
	if FileAccess.file_exists(save_file_path):
		var file := FileAccess.open(save_file_path, FileAccess.READ)
		if file:
			last_scores = file.get_var()
			max_scores = file.get_var()
		else:
			push_error("❌ Erreur ouverture fichier de sauvegarde.")
	else:
		print("No data saved ... initialising scores.")
		for i in range(number_of_maps):
			last_scores[i] = 0
			max_scores[i] = 0

func reset_scores() -> void:
	for i in range(number_of_maps):
		last_scores[i] = 0
		max_scores[i] = 0
	save()
