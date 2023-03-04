require 'find'
require 'fileutils'

puts "Please choose the folder which you wish to clean up:"

folders = {
  '0' => downloads_folder = File.join(Dir.home, 'Downloads'),
  '3' => documents_folder = File.join(Dir.home, 'Documents'),
  '9' => desktop_folder = File.join(Dir.home, 'Desktop')
}

list_options = folders.each {|key, folder| puts "[#{key}] - #{File.basename(folder)}"}
user_choice = folders[gets.chomp]

until user_choice
  puts "Invalid option. Please try again."
  list_options
  user_choice = folders[gets.chomp]
end

puts "Cleaning up #{File.basename(user_choice)}....🧹🧹🧹"

## Arrays used in the filtering logic.
current_year = Time.now.year
yearly_folders = (current_year - 20..current_year + 20).to_a.map(&:to_s)

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

organize_downloads(user_choice, yearly_folders)
