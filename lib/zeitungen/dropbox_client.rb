module Dropbox
  class Client

    attr_accessor :date_string

    def public_dest_path(filename)
      File.join("/","quotidie", @date_string, filename)
    end

    def private_dest_path(filename)
      File.join("/","zeitungen", filename)
    end

    def exist_in_public_dest?(filename)
      exists?(public_dest_path(filename))
    end

    def exist_in_private_dest?(filename)
      exists?(private_dest_path(filename))
    end

    def mv_file_in_public_dest(filename, file)
      f = open(file)
      upload(public_dest_path(filename), f)
    end

    def mv_file_in_private_dest(filename, file)
      f = open(file)
      upload(private_dest_path(filename), f)
    end

    def include?(dir, file)
      r = get_metadata(dir)
      r["contents"].map{|e| File.basename(e["path"])}.include?(file)
    end

    def dir?(path) # valid: "/a/b",  not valid: "a/b" or "/a/b/"
      path = "/#{path}" unless path[0]=="/"
      r = get_metadata(path)
      r.is_a? Dropbox::FolderMetadata
    end


    # path can be a dir or a file
    def exists?(path)
      path = "/#{path}" unless path[0]=="/"
      r = get_metadata(path)
      return !r["is_deleted"]
    rescue ClientError => e
      false 
    rescue ApiError => e
      puts "Error thrown on checking existence of '#{path}'"
      false
    end
  end  
end
