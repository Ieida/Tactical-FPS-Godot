extends Command
class_name QuitCommand

func run(args):
	CommandConsole.get_tree().quit()
