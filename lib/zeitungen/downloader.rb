module Zeitungen
  class Downloader
    def initialize(url, zeitungen, client, password, verbose: false)
      @url       = url
      @zeitungen = zeitungen
      @client    = client
      @password  = password
      @verbose   = verbose
    end
    
    def run(date=Date.today, options={})
      options = {thread_count: 5}.merge(options)
      @date_string = date.strftime("%Y-%m-%d")
      @client.date_string = @date_string

      page = IndexPage.new(@url, @password)
      zeitungen_links = page.links(date)
      puts "zeitungen_links.size: #{zeitungen_links.size}" if @verbose
      # puts zeitungen_links.inspect
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
      @zeitungen.each do |z|
        if (links = zeitungen_links.find_all{|l| z.regexp.match l.text }).any? # se c'è un link per il zeitungen corrente
          if links.size==1
            link = links.first
          else # links.size>2
            if z.but_not
              if (links = links.reject{|l| z.but_not.match l.text}).any?
                link = links.first
              else
                link = nil
              end
            else
              link = links.first
            end
          end
          if link
            uri = link.uri
            puts "uri: #{uri.inspect}" if @verbose
            if uri.host=="t.umblr.com"
              h = Hash[uri.query.split("&").map{|e| e.split("=")}]
              u = URI(URI.unescape(h["z"])+"\?directDownload\=true")
              puts "u: #{u}" if @verbose
              z.uri = u
            else
              z.uri = uri+"\?directDownload\=true"   # zeitungen.uri+"\?directDownload\=true"
            end
            filename = filename_w_date(z.final_name) # "Corriere della Sera - 2015-12-23.pdf"

            queue << z if !(@client.exist_in_public_dest?(filename) || @client.exist_in_private_dest?(filename))            
          end
        end
      end
      queue
    end

    def download(queue, thread_count)
      threads = thread_count.times.map do
        Thread.new do    
          while !queue.empty? && z = queue.pop
            begin
              url = z.uri
              file = Tempfile.new('zeitungen')


              res = HTTP.get(url)
              i = 0
              puts "Response status: #{res.status.to_s}" if @verbose
              while res.status.to_s=="302 Found" and i<5 # max 5 redirect
                url = res.headers.get("Location")
                url = url.first if url.is_a? Array
                puts "Redirect URL: #{url}" if @verbose
                res = HTTP.get(url)
                puts "Response status: #{res.status.to_s}" if @verbose
                i += 1
              end
              puts "downloading #{z.final_name} (#{url})..."
              file.write(res.to_s)


              # res = HTTP.get()
              # Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme=='https') do |http|
              #   request = Net::HTTP::Get.new(uri)
              #   puts "downloading #{z.final_name} (#{z.uri})..."
              #   response = http.request request
              #   file.write(response.body)
              # end

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
