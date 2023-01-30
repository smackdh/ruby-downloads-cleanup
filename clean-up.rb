require 'find'
require 'fileutils'


downloads_folder = File.join(Dir.home, "Downloads")
yearly_folders = ["2019", "2020", "2021", "2022", "2023", "2024", "2025"]

Dir.foreach(downloads_folder) do |entry|
  next if entry == "." || entry == ".." || yearly_folders.include?(entry)

  path = File.join(downloads_folder, entry)
  next unless File.exists?(path)

  last_edited = File.mtime(path)
  year = last_edited.strftime("%Y")
  new_directory = ("#{downloads_folder}/#{year}")

  unless File.directory?(new_directory)
    puts "Create Folder"
    Dir.mkdir(new_directory)
  end

  if path != new_directory
    FileUtils.mv(path,new_directory)
  end
end
