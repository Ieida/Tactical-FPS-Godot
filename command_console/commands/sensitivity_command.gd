extends Command
class_name SensitivityCommand

func run(args: PackedStringArray):
	if args.size() < 1:
		CommandConsole.print_warning("No value provided, sensitivity was not changed")
		return
	var new_value = args[0] as String
	if not new_value.is_valid_float():
		CommandConsole.print_error("Invalid value %s" % new_value)
		return
	else:
		new_value = new_value as float
		Settings.set_setting(&"sensitivity", new_value)
