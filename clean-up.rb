require 'find'
require 'fileutils'


downloads_folder = File.join(Dir.home, "Downloads")

## Array of years, used in the filtering logic.
yearly_folders = ["2019", "2020", "2021", "2022", "2023", "2024", "2025"]

Dir.foreach(downloads_folder) do |file|
## Filtering logic.
## Skip Subfolders and Foldersnames included in "yearly_folders" array.
  next if file == "." || file == ".." || yearly_folders.include?(file)

  ## Makes creates a string for the path of the file/directory
  path = File.join(downloads_folder, file)
  next unless File.exists?(path)

  ## Getting the modified date of the file/directory.
  last_edited = File.mtime(path)
  year = last_edited.strftime("%Y")
  new_directory = ("#{downloads_folder}/#{year}")

  ## If a folder with modified file's year does not exist - create it.
  unless File.directory?(new_directory)
    puts "Create Folder"
    Dir.mkdir(new_directory)
  end

  ## If the file/directory is NOT the same as the new_directory, move it to the new directory.
  if path != new_directory
    FileUtils.mv(path,new_directory)
  end
end
