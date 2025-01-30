extends Node

class_name Update_Player_Position

@export_multiline var Summary : String
@export var nav_agent : NavigationAgent3D # réference au Navigation_agent


# Fonction pour permettre au navigation agent de mettre a jour la position de sa cible
func _update_target_position(target_position): # Fonction qui attend en entrée un vecteur3 qui sera la position du joueur
	nav_agent.set_target_position(target_position) # fonction propore aux navigation agent qui attend pour entrée un vecteur3 qui lui sera donné lorsque la fonction update_target_position sera appelé.
