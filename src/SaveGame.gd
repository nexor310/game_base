class_name SaveGame
extends Resource


const SAVE_PATH = "user://save.tres"

export var speed: int


func saveGame() -> void:
	ResourceSaver.save(SAVE_PATH, self)

static func saveExists() -> bool:
	return ResourceLoader.exists(SAVE_PATH)

static func load() -> Resource:
	return ResourceLoader.load(SAVE_PATH, "", true)
