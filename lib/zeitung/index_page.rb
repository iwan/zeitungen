class IndexPage
  def initialize(url, passwords)
    @url       = url
    @passwords = passwords
  end
  
  def links(date)
    date_string = date.to_s # date.strftime("%Y-%m-%d")
    t = Time.now
    all_quotidie_links = []

    puts "Downloading zeitungs for #{date_string}"
    puts "-----------------------------------"

    agent = Mechanize.new 
    agent.get(@url) do |page|
      
      # compilo form autenticazione
      form = page.forms.first
      form.password = @passwords.get(date.year, date.month)
      
      # non so perche arriva un'altro form precompilato 
      form2 = agent.submit(form).forms.first

      # la pagina con i diversi giorni
      quotidie_page = agent.submit(form2)

      # finalmente l'url della pagina con la lista dei quotidiani
      rgxp = Regexp.new("^"+date.strftime("%d.%m.%Y"))
      page = quotidie_page

      # tutti i link utili
      [1,2,3].each do |a|
        all_quotidie_links = page.links.find_all { |link| link.attributes.parent.parent.path == "/html/body/section/section/div/article[#{a}]/div/section[1]/div/div" }
        break if all_quotidie_links.size > 3  
      end
    end
    puts "Parsing zeitung page takes #{Time.now-t}s"
    all_quotidie_links  
  end
end