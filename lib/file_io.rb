require './lib/photograph'
require './lib/artist'
require 'CSV'

class FileIO

  def load_photographs(file_path)
    CSV.foreach(file_path, headers: true, header_converters: :symbol) do |row|
      add_photograph(Photograph.new(row))
    end
  end
end
