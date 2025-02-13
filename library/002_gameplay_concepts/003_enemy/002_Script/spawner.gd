extends Node3D

@export var spawner_timer: Timer 
@export var max_enemies : float # max enemies_spawn
@onready var enemies_spawned : float = 0 # nombre d'ennemi spawner

const SLIME = preload("res://library/002_gameplay_concepts/003_enemy/001_SCENE/slime.tscn")# charge le slime depuis les folder


#fonction propre a godot qui gère automatique le spawn
#il gère le délai d'apparition en automatique
func _on_spawner_timer_timeout() -> void: 
	
	#condition pour limité le nombre de slime qui est spawner
	if enemies_spawned  >= max_enemies : # si les ennemis spawned sont superieur ou égal amax_ennemi
		print("spawn !")
		spawner_timer.stop() # stope le spawn
		return
		
	var newEnemy = SLIME.instantiate() # variable qui instancie le slime
	get_parent().add_child(newEnemy) # récupére le noeud qui contien mon spawner et ajoute newEnemy comme enfant de ce node
	#newEnemy.global_position -> Position de mon ennemi   =  global_position -> position de mon spawner
	newEnemy.global_position = global_position # place l'ennemy exatement a l'endroit ou se trouve mon spawner
	
	enemies_spawned += 1 # incrémentation de l'apparition de mes ennemi 
