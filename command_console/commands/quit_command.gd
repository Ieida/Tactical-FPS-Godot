extends Command
class_name QuitCommand

func run(_args):
	CommandConsole.get_tree().quit()
