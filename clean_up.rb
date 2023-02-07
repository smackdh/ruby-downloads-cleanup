require 'find'
require 'fileutils'

downloads_folder = File.join(Dir.home, 'Downloads')
## Arrays used in the filtering logic.
yearly_folders = ["2019", "2020", "2021", "2022", "2023", "2024", "2025"]

def check_type(file)
  case file
  when /^.*\.(pdf|doc|docx|PAGES|txt)$/i
    'documents'
  when /^.*\.(gif|jpg|jpeg|png|svg|mp4|mov|mp3|mpeg4|heic)$/i
    'media'
  when /^.*\.(dmg|exe|jar)$/i
    'programs'
  when /^.*\.(zip|tar|rar)$/i
    'archives'
  else
    'other'
  end
end

def create_directory(directory, subfolder)
  final_directory = File.join(directory, subfolder)
  Dir.mkdir(final_directory) unless File.directory?(final_directory)
  final_directory
end

def move_file(file, directory)
  final_directory = create_directory(directory, check_type(file))
  FileUtils.mv(file, final_directory) unless file === directory
end

def organize_downloads(downloads_folder, yearly_folders)
  Dir.foreach(downloads_folder) do |file|
    next if file == '.' || file == '..' || yearly_folders.include?(file)

    path = File.join(downloads_folder, file)
    next unless File.exist?(path)

    last_edited = File.mtime(path)
    year = last_edited.strftime('%Y')
    new_directory = create_directory(downloads_folder, year)

    move_file(path, new_directory)
  end
end

organize_downloads(downloads_folder, yearly_folders)
