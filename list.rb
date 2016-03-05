require 'sequel'

#Setting up the SQLite3 db

module List

  puts @DB

  def getTest 
    test = @DB[:test]
    test
  end
end
