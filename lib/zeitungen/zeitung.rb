module Zeitungen
  class Zeitung
    attr_accessor :uri
    attr_reader :final_name, :regexp, :upload, :but_not
    def initialize(final_name, regexp, upload: false, but_not: nil)
      @final_name = final_name
      @regexp = regexp
      @upload = upload
      @uri = nil
      @but_not = but_not
    end


    def download
      puts "downloading '#{final_name}'..."
      file = nil
      begin
        file = Tempfile.new('zeitungen')
        open(uri+"\?directDownload\=true", "rb") do |read_file|
          file.write(read_file.read)
        end
      rescue Exception => e
        puts "Error downloading '#{final_name}'!"
      end
      file
    end
  end  
end
