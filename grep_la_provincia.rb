require 'mechanize'
require 'http'
require 'pdf-reader'
require 'date'
require 'fileutils'
require 'dropbox_sdk'



def search_zeitung_within_precari_pages(zeitung_pattern, agent: Mechanize.new { |a| a.user_agent_alias = 'Mac Safari' }, &block) 
  arr = (1..12).to_a.sort!{|x,y| (6.8-x).abs<=>(6.8-y).abs} # [7, 6, 8, 5, 9, 4, 10, 3, 11, 2, 12, 1]
  arr.each do |n|
    url = yield(n.to_s.rjust(3,'0'))
    if download_url = search_zeitung_within_precari(url, zeitung_pattern, agent: agent)
      return download_url
    end
  end
  nil
end


# Cerca all'interno della pagina page_url l'URL relativo al giornale ricercato tramite pattern zeitung_pattern
# ritorna l'URL per il download del file
def search_zeitung_within_precari(page_url, zeitung_pattern, agent: Mechanize.new { |a| a.user_agent_alias = 'Mac Safari' })
  puts "getting page #{page_url}"
  agent.get(page_url) do |page|
    if link = page.link_with(text: zeitung_pattern)
      page_with_desired_zeitung = agent.click(link) # page_with_desired_zeitung is a Mechanize::Page obj
      puts "Link found!"
      dl_link = page_with_desired_zeitung.at("input.jsDLink")      
      return dl_link.attribute("value") if dl_link      
    end
  end
  nil
end


def download(url, tempfile)
  puts "downloading #{url}..."
  res = HTTP.get(url)
  tempfile.write(res.to_s)
  puts " completed!"
  tempfile.path
end


module PDF
  class Reader    
    def creation_date
      s_date = info[:CreationDate]
      Date.parse(s_date[2...10])
    rescue
      nil
    end
  end
end


# sposta e rinomina original_filepath -> destination_dir + final_name
def move_and_rename(original_filepath, destination_dir, final_name)
  FileUtils.mkdir_p(destination_dir)
  final_path = File.join(destination_dir, final_name)
  raise "Final file '#{final_name}' already existing in '#{destination_dir}' directory" if File.exists?(final_path)

  FileUtils.cp original_filepath, destination_dir
  File.rename(File.join(destination_dir, File.basename(original_filepath)), final_path)
end



_4sync_precari_url_id = ENV["_4SYNC_PRECARI_URL_ID"]
agent = Mechanize.new { |a| a.user_agent_alias = 'Mac Safari' }

zeitung = {}
zeitung[:regex] = /provincia pavese/i
zeitung[:final_basename] = "Provincia Pavese"
destination_dir = File.join(Dir.home, "Downloads")

client     = DropboxClient.new(ENV["ZEITUNG_DB_ACCESS_TOKEN"], "dropbox")

download_url = search_zeitung_within_precari_pages(zeitung[:regex], agent: agent){|s| "https://www.4sync.com/folder/#{_4sync_precari_url_id}/#{s}/Precari.html"}

tempfile = Tempfile.new("zeitung")
begin
  tempfile_path = download(download_url, tempfile)

  date_string    = PDF::Reader.new(tempfile_path).creation_date.strftime('%Y-%m-%d')
  final_name = "#{zeitung[:final_basename]} - #{date_string}.pdf"

  move_and_rename(tempfile_path, destination_dir, final_name)

  f = open(File.join(destination_dir, final_name)) # se il precedente comando è andato a buon fine!!!
  client.put_file(File.join("quotidie", date_string, final_name), f)

rescue Exception => e
  raise e

ensure
  tempfile.close
  tempfile.unlink
end

# non si può rinominare un tempfile dentro la sua directory?



# pattern di ricerca
# nome finale
# destinazione (su Dropbox)

# data