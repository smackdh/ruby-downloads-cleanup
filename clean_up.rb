require 'find'
require 'fileutils'

puts "Please choose the folder which you wish to clean up:"
# puts Dir.glob(Dir.home + "/*")
# List the three as options
# Give an option to pick one [0, 3, 9]

downloads_folder = File.join(Dir.home, 'Downloads')
documents_folder = File.join(Dir.home, 'Documents')
desktop_folder = File.join(Dir.home, 'Desktop')
puts "[0] - " + File.basename(downloads_folder)
puts "[3] - " + File.basename(documents_folder)
puts "[9] - " + File.basename(desktop_folder)

user_input = gets
user_choice = ""
if user_input == '0'
  user_choice = downloads_folder
elsif user_input == '3'
  user_choice = documents_folder
elsif user_input == '9'
  user_choice = desktop_folder
else  puts "Please choose the folder which you wish to clean up:"
puts "[0] - " + File.basename(downloads_folder)
puts "[3] - " + File.basename(documents_folder)
puts "[9] - " + File.basename(desktop_folder)
end

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

def organize_downloads(user_choice, yearly_folders)
  Dir.foreach(user_choice) do |file|
    next if file == '.' || file == '..' || yearly_folders.include?(file)

    path = File.join(user_choice, file)
    next unless File.exist?(path)

    last_edited = File.mtime(path)
    year = last_edited.strftime('%Y')
    new_directory = create_directory(user_choice, year)

    move_file(path, new_directory)
  end
end

organize_downloads(downloads_folder, yearly_folders)
