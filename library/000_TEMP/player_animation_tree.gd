extends AnimationTree

enum {
	idle,
	walk,
	run
}



var state

func change_state_to_idle():
	state == idle
	
func change_state_to_walk():
	state == walk


func change_state_to_run():
	state == run
