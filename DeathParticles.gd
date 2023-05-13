extends CPUParticles2D


func explode():
	reparent(GeneralLogic.get_world())
	emitting = true
	get_tree().create_timer(lifetime).timeout.connect(queue_free)
