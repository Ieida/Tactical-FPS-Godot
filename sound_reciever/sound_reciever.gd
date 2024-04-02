extends Area3D
class_name  SoundReciever

signal recieved(sound: Sound)

func recieve(sound: Sound):
	recieved.emit(sound)
