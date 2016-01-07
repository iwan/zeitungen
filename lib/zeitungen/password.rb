module Zeitungen
  class Password
    attr_reader :year, :month, :passphrase
    def initialize(year, month, passphrase)
      @year = year.to_i
      @month = month.to_i
      @passphrase = passphrase
    end 
  end
  
end
