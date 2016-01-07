module Zeitungen
  class FileClient
    attr_accessor :date_string

    def public_dest_path(filename)
      File.join(Dir.home, "Dropbox", "quotidie", @date_string, filename)
    end

    def private_dest_path(filename)
      File.join(Dir.home, "Dropbox", "zeitungenen", filename)
    end

    def exist_in_public_dest?(filename)
      File.exists?(public_dest_path(filename))
    end

    def exist_in_private_dest?(filename)
      File.exists?(private_dest_path(filename))
    end

    def mv_file_in_public_dest(filename, file)
      FileUtils.mv(file.path, public_dest_path(filename))
    end

    def mv_file_in_private_dest(filename, file)
      FileUtils.mv(file.path, private_dest_path(filename))
    end
  end  
end
