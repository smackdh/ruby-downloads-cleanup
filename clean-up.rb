require 'find'
require 'fileutils'

downloads_folder = "/Users/mattiaswelamsson/Downloads"

Dir.foreach(downloads_folder) do |entry|
  ## PATH.
  path = "#{downloads_folder}/#{entry}"
  last_edited = File.mtime(path)
  year = last_edited.strftime("%Y")
  next if entry == "." || entry == ".."

  new_directory = ("#{downloads_folder}/#{year}")

  ## CREATES YEARLY FOLDER IF IT DOESN'T EXIST
  unless File.directory?(new_directory)
    puts "Create Folder"
    Dir.mkdir(new_directory)
  end


  if File.directory?(path)
    # puts "\#{entry} is a DIRECTORY and was last edited #{year}\n"

  elsif File.file?(path)
    if year === "2022"
      FileUtils.mv(path,new_directory)
    end
    puts "#{entry} is a FILE and was last edited #{year}"
  end


end


##För varje år som hittas, skapa en mapp.
##Flytta alla filer från 2023 till mappen 2023
