require 'find'
require 'fileutils'

downloads_folder = "/Users/mattiaswelamsson/Downloads"

Dir.foreach(downloads_folder) do |entry|
  path = "#{downloads_folder}/#{entry}"
  last_edited = File.mtime(path)
  year = last_edited.strftime("%Y")
  # next if entry == "." || entry == ".."
  if File.directory?(path)
    puts "#{entry} is a directory and was last edited #{year}"
  elsif File.file?(path)
    puts "#{entry} is a FILE and was last edited #{year}"
    puts path
  end
end


##För varje år som hittas, skapa en mapp.
##Flytta alla filer från 2023 till mappen 2023
