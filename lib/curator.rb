require './lib/file_io'

class Curator < FileIO
  attr_reader :photographs, :artists

  def initialize
    @photographs = []
    @artists = []
  end

  def add_photograph(photo)
    @photographs << photo
  end

  def add_artist(artist)
    @artists << artist
  end

  def find_artist_by_id(id)
    @artists.find do |artist|
      artist.id == id
    end
  end

  def find_photograph_by_id(id)
    @photographs.find do |photograph|
      photograph.id == id
    end
  end

  def find_photographs_by_artist(artist)
    @photographs.find_all do |photograph|
      photograph.artist_id == artist.id
    end
  end

  def artists_with_multiple_photographs
    @artists.find_all do |artist|
      find_photographs_by_artist(artist).length > 1
    end
  end

  def photographs_taken_by_artist_from(country)
    country_artists = @artists.find_all do |artist|
      artist.country == country
    end
    country_artists.map do |artist|
      find_photographs_by_artist(artist)
    end.flatten
  end

  def photographs_taken_between(range)
    @photographs.find_all do |photo|
      range.first < photo.year.to_i && photo.year.to_i < range.last
      
    end
  end
end
