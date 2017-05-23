require 'date'
require_relative 'lib/zeitungen'

zeitungs = []
zeitungs << Zeitung.new("Milano Finanza", /milano finanza/i, true)
zeitungs << Zeitung.new("Corriere della Sera", /corriere della sera/i, true)
zeitungs << Zeitung.new("Corriere Economia", /corriere della sera economia/i, true) # lunedì
zeitungs << Zeitung.new("Gazzetta dello Sport", /gazzetta dello sport/i, true)
zeitungs << Zeitung.new("Fatto Quotidiano", /fatto quotidiano/i, true)
zeitungs << Zeitung.new("Repubblica", /repubblica/i, true)
zeitungs << Zeitung.new("Sole 24 Ore", /sole 24 ore/i, true)
zeitungs << Zeitung.new("Stampa", /stampa/i, true)
zeitungs << Zeitung.new("Centro", /centro/i, true)
zeitungs << Zeitung.new("Foglio", /foglio/i, false)
zeitungs << Zeitung.new("Repubblica Roma", /Rep.locale\-RM/i, false)
zeitungs << Zeitung.new("Corriere Milano", /Corriere della Sera Milano/i, false)
zeitungs << Zeitung.new("Giornale", /giornale/i, false)
zeitungs << Zeitung.new("Libero", /libero/i ,false)

zeitungs << Zeitung.new("Corriere Lettura", /corriere della sera.+lettura/i ,true) # domenica
zeitungs << Zeitung.new("Stampa Tuttolibri", /stampa.+libri/i, true) # sabato
zeitungs << Zeitung.new("Sole 24 Ore Plus", /sole 24 ore plus/i, true) # sabato
zeitungs << Zeitung.new("Manifesto", /manifesto/i, true)


url        = ENV["URL"]
year_month = Date.today.strftime("%Y%m") # "201705"
password   = ENV["PWD_#{year_month}"]
client     = DropboxClient.new(ENV["ZEITUNG_DB_ACCESS_TOKEN"], "dropbox")
puts "url: #{url.inspect}"


g = Downloader.new(url, zeitungs, client, password)
g.run
