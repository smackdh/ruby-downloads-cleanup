require 'find'
require 'fileutils'

downloads_folder = File.join(Dir.home, 'Downloads')

## Arrays used in the filtering logic.
yearly_folders = ["2019", "2020", "2021", "2022", "2023", "2024", "2025"]
archive_filetypes = [".tar", ".rar", ".zip"]
# app_filetypes = [".dmg"]
# image_filetypes = [".gif", ".jpg", ".mp4", ".mov", ".png", ".svg", ".jpeg"]
# document_filetypes = [".pdf", ".docx", ".pages"]
# document_filetypes = "/^.*\.(pdf|PDF|doc|DOC|docx|DOCX|PAGES|pages)$/"

def check_type(file, directory)
  case file
  when /^.*\.(pdf|PDF|doc|DOC|docx|DOCX|PAGES|pages|txt|TXT)$/
    puts 'DOCUMENT MATCH'
    unless File.directory?("#{directory}/documents")
      puts 'Creating documents folder'
      Dir.mkdir("#{directory}/documents")
    end
    final_dir = "#{directory}/documents"
    file != directory ? FileUtils.mv(file, final_dir) : ''
  when /^.*\.(gif|GIF|jpg|JPG|jpeg|JPEG|png|PNG|svg|SVG|mp4|MP4|mov|MOV|mp3|MP3|mpeg4|MPEG4|heic|HEIC)$/
    puts 'MEDIA MATCH'
    unless File.directory?("#{directory}/media")
      puts 'Creating media folder'
      Dir.mkdir("#{directory}/media")
    end
    final_dir = "#{directory}/media"
    file != directory ? FileUtils.mv(file, final_dir) : ''
  when /^.*\.(dmg|DMG|exe|EXE|jar|JAR)$/
    puts 'PROGRAM MATCH'
    unless File.directory?("#{directory}/programs")
      puts 'CREATING PROGRAM folder'
      Dir.mkdir("#{directory}/programs")
    end
    final_dir = "#{directory}/programs"
    file != directory ? FileUtils.mv(file, final_dir) : ''
  when /^.*\.(zip|ZIP|tar|TAR|rar|RAR)$/
    puts 'ARCHIVE MATCH'
    unless File.directory?("#{directory}/archives")
      puts 'CREATING ARCHIVES folder'
      Dir.mkdir("#{directory}/archives")
    end
    final_dir = "#{directory}/archives"
    file != directory ? FileUtils.mv(file, final_dir) : ''
  else
    puts 'NOT A MATCH...'
    file != directory ? FileUtils.mv(file, directory) : ''
  end
end


Dir.foreach(downloads_folder) do |file|
  # Filtering logic.
  # Skip Subfolders and Foldersnames included in "yearly_folders" array.
  next if file == '.' || file == '..' || yearly_folders.include?(file)

  ## Makes creates a string for the path of the file/directory
  path = File.join(downloads_folder, file)
  next unless File.exist?(path)

  ## Getting the modified date of the file/directory.
  last_edited = File.mtime(path)
  year = last_edited.strftime('%Y')
  new_directory = "#{downloads_folder}/#{year}"
  ## If a folder with modified file's year does not exist - create it.
  unless File.directory?(new_directory)
    puts 'Create Folder'
    Dir.mkdir(new_directory)
  end
  check_type(path, new_directory)
  ## If the file/directory is NOT the same as the new_directory, move it to the new directory.
end
