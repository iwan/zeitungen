module Zeitungen
  class Passwords
    def initialize(hash)
      @arr = []
      hash.each_pair do |year, hash2|
        hash2.each_pair do |month, passphrase|
          @arr << Password.new(year, month, passphrase)
        end
      end
    end
    
    def get(year, month)
      if p = @arr.find{|e| e.year==year.to_i && e.month==month.to_i}
        p.passphrase
      else
        raise Exception.new("Password not found!")
      end
    end
  end
  
end
