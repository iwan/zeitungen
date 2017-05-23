module Zeitungen
  class IndexPage
    def initialize(url, password)
      @url       = url
      @password = password
    end
    
    def links(date)
      date_string = date.to_s # date.strftime("%Y-%m-%d")
      t = Time.now
      all_quotidie_links = []

      puts "Downloading zeitungens for #{date_string}"
      puts "-----------------------------------"

      agent = Mechanize.new 
      agent.get(@url) do |page|
        
        # compilo form autenticazione
        form          = page.forms.first
        form.password = @password
        
        # non so perche arriva un'altro form precompilato 
        form2 = agent.submit(form).forms.first

        # la pagina con i diversi giorni
        quotidie_page = agent.submit(form2)

        # finalmente l'url della pagina con la lista dei quotidiani
        rgxp = Regexp.new("^"+date.strftime("%d.%m.%Y"))
        page = quotidie_page
        # puts page
        # exit
        puts "-----"
        puts page.links.map{|l| "#{l} -> #{l.attributes.parent.parent.path}"}.inspect
        # /html/body/section/section/div/div[1]/article[1]/div/section[1]/div/div

        # tutti i link utili
        [0,1,2,3].each do |a|
          all_quotidie_links = page.links.find_all { |link| link.attributes.parent.parent.path == "/html/body/section/section/div/article[#{a}]/div/section[1]/div/div" }
          break if all_quotidie_links.size > 3  
        end

        if all_quotidie_links.size==0
          [0,1,2,3].each do |a|
            all_quotidie_links = page.links.find_all { |link| link.attributes.parent.parent.path == "/html/body/section/section/div/div/article[#{a}]/div/section[1]/div/div" }
            break if all_quotidie_links.size > 3  
          end
        end
        if all_quotidie_links.size==0
          [0,1,2,3].each do |a|
            all_quotidie_links = page.links.find_all do |link|

              link.attributes.parent.parent.path == "/html/body/section/section/div/div[1]/article[#{a}]/div/section[1]/div/div"

            end
            break if all_quotidie_links.size > 3  
          end
        end
      end
      puts "Parsing zeitungen page takes #{Time.now-t}s"
      all_quotidie_links  
    end
  end  
end
