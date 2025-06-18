extends Node
func save_to_file(content, filePath):
	if !FileAccess.file_exists(filePath):
		printerr("File " + filePath + " not found!")
	var file = FileAccess.open(filePath, FileAccess.WRITE)
	file.store_string(content)

func load_from_file(filePath):
	if !FileAccess.file_exists(filePath):
		printerr("File " + filePath + " not found!")
		return null
	var file = FileAccess.open(filePath, FileAccess.READ)
	var content = file.get_as_text()
	return content
