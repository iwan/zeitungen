class Passwords
  def initialize(hash)
    @arr = []
    hash.each_pair do |year, hash2|
      hash2.each_pair do |month, passphrase|
        @arr.add Password.new(year, month, passphrase)
      end
    end
  end
  
  def get(year, month)
    @arr.find{|e| e.year==year.to_i && e.month==month.to}
  end
end
