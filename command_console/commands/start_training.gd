extends Command
class_name StartTrainingCommand

const training_scene: PackedScene = preload("res://missions/training/scene/training_level.tscn")

func run(_args):
	var o: RichTextLabel = CommandConsole.output
	o.push_paragraph(HORIZONTAL_ALIGNMENT_LEFT)
	o.add_text("Starting training level.")
	o.pop()
	CommandConsole.get_tree().change_scene_to_packed(training_scene)
