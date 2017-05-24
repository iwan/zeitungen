require 'date'
require_relative 'lib/zeitungen'

zeitungs = []
# zeitungs << Zeitung.new("Milano Finanza", /milano finanza/i, upload: true)
# zeitungs << Zeitung.new("Corriere della Sera", /corriere della sera/i, upload: true)
# zeitungs << Zeitung.new("Corriere Economia", /corriere della sera economia/i, upload: true) # lunedì
# zeitungs << Zeitung.new("Gazzetta dello Sport", /gazzetta dello sport/i, upload: true)
# zeitungs << Zeitung.new("Fatto Quotidiano", /fatto quotidiano/i, upload: true)
# zeitungs << Zeitung.new("Repubblica", /repubblica/i, upload: true)
# zeitungs << Zeitung.new("Sole 24 Ore", /sole 24 ore/i, upload: true)
# zeitungs << Zeitung.new("Stampa", /stampa/i, upload: true)
# zeitungs << Zeitung.new("Centro", /centro/i, upload: true)
# zeitungs << Zeitung.new("Foglio", /foglio/i, upload: false)
# zeitungs << Zeitung.new("Repubblica Roma", /Rep.locale\-RM/i, upload: false)
# zeitungs << Zeitung.new("Corriere Milano", /Corriere della Sera Milano/i, upload: false)
zeitungs << Zeitung.new("Giornale", /giornale/i, upload: false, but_not: /italia/i)
# zeitungs << Zeitung.new("Libero", /libero/i , upload: false)

# zeitungs << Zeitung.new("Corriere Lettura", /corriere della sera.+lettura/i , upload: true) # domenica
# zeitungs << Zeitung.new("Stampa Tuttolibri", /stampa.+libri/i, upload: true) # sabato
# zeitungs << Zeitung.new("Sole 24 Ore Plus", /sole 24 ore plus/i, upload: true) # sabato
# zeitungs << Zeitung.new("Manifesto", /manifesto/i, upload: true)


url        = ENV["URL"]
year_month = Date.today.strftime("%Y%m") # "201705"
password   = ENV["PWD_#{year_month}"]
client     = DropboxClient.new(ENV["ZEITUNG_DB_ACCESS_TOKEN"], "dropbox")
puts "url: #{url.inspect}"


g = Downloader.new(url, zeitungs, client, password, verbose: true)
g.run
