module Zeitungen
  class Downloader
    def initialize(url, zeitungens, client, passwords)
      @url       = url
      @zeitungens  = zeitungens
      @client    = client
      @passwords = passwords
    end
    
    def run(date=Date.today, options={})
      options = {thread_count: 5}.merge(options)
      @date_string = date.strftime("%Y-%m-%d")
      @client.date_string = @date_string

      page = IndexPage.new(@url, @passwords)
      zeitungen_links = page.links(date)
      queue = enqueue(zeitungen_links)

      if queue.size==0
        puts "No zeitungen to download"
      else
        puts "Start downloading #{queue.size} zeitungen"
      end
      
      download(queue, options[:thread_count])
    end

    private

    def filename_w_date(filename, date_string=nil)
      "#{filename} - #{date_string || @date_string}.pdf"
    end

    def enqueue(zeitungen_links)
      queue = Queue.new
      @zeitungens.each do |z|
        if link = zeitungen_links.find{|l| z.regexp.match l.text } # se c'è un link per il zeitungen corrente
          z.uri = link.uri+"\?directDownload\=true"   # zeitungen.uri+"\?directDownload\=true"
          filename = filename_w_date(z.final_name) # "Corriere della Sera - 2015-12-23.pdf"

          queue << z if !(@client.exist_in_public_dest?(filename) || @client.exist_in_private_dest?(filename))
        end
      end
      queue
    end

    def download(queue, thread_count)
      threads = thread_count.times.map do
        Thread.new do    
          while !queue.empty? && z = queue.pop
            begin
              uri = z.uri
              file = Tempfile.new('zeitungen')
              Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme=='https') do |http|
                request = Net::HTTP::Get.new(uri)
                puts "downloading #{z.final_name}..."
                response = http.request request
                file.write(response.body)
              end

              filename = filename_w_date(z.final_name)
              z.upload ? @client.mv_file_in_public_dest(filename, file) : @client.mv_file_in_private_dest(filename, file)
              file.close
              file.unlink

            rescue Exception => e
              puts "Error downloading a newpaper!"
              puts e.inspect
            end
          end
        end
      end
      threads.each(&:join)
      puts "Main thread finish here!"
    end
  end  
end
