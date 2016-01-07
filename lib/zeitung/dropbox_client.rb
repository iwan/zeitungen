class DropboxClient
  attr_accessor :date_string

  def public_dest_path(filename)
    File.join("quotidie", @date_string, filename)
  end

  def private_dest_path(filename)
    File.join("zeitungen", filename)
  end

  def exist_in_public_dest?(filename)
    exists?(public_dest_path(filename))
  end

  def exist_in_private_dest?(filename)
    exists?(private_dest_path(filename))
  end

  def mv_file_in_public_dest(filename, file)
    f = open(file)
    put_file(public_dest_path(filename), f)
  end

  def mv_file_in_private_dest(filename, file)
    f = open(file)
    put_file(private_dest_path(filename), f)
  end

  def include?(dir, file)
    r = metadata(dir)
    r["contents"].map{|e| File.basename(e["path"])}.include?(file)
  end

  def dir?(path)
    r = metadata(path)
    r["is_dir"]
  end

  def create_folder(path)
    file_create_folder(path)
  rescue DropboxError => e
    nil
  end

  # path can be a dir or a file
  def exists?(path)
    r = metadata(path)
    return !r["is_deleted"]
  rescue DropboxError => e
    false 
  end
end
