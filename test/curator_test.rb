require 'minitest/autorun'
require 'minitest/pride'
require './lib/photograph'
require './lib/artist'
require './lib/curator'

class CuratorTest < Minitest::Test

  def setup
    @curator = Curator.new

    @photo_1 = Photograph.new({
      id: "1",
      name: "Rue Mouffetard, Paris (Boy with Bottles)",
      artist_id: "1",
      year: "1954"
      })

    @photo_2 = Photograph.new({
      id: "2",
      name: "Moonrise, Hernandez",
      artist_id: "2",
      year: "1941"
      })

    @photo_3 = Photograph.new({
      id: "3",
      name: "Identical Twins, Roselle, New Jersey",
      artist_id: "3",
      year: "1967"
      })

    @photo_4 = Photograph.new({
      id: "4",
      name: "Monolith, The Face of Half Dome",
      artist_id: "3",
      year: "1927"
      })

    @artist_1 = Artist.new({
      id: "1",
      name: "Henri Cartier-Bresson",
      born: "1908",
      died: "2004",
      country: "France"
      })

    @artist_2 = Artist.new({
      id: "2",
      name: "Ansel Adams",
      born: "1902",
      died: "1984",
      country: "United States"
      })

    @artist_3 = Artist.new({
      id: "3",
      name: "Diane Arbus",
      born: "1923",
      died: "1971",
      country: "United States"
      })
  end

  def test_it_exists
    assert_instance_of Curator, @curator
  end

  def test_it_initializes_with_no_photographs
    curator = Curator.new
    assert_equal [], curator.photographs
  end

  def test_photographs_can_be_added_to_curator
    @curator.add_photograph(@photo_1)
    @curator.add_photograph(@photo_2)

    assert_equal [@photo_1, @photo_2], @curator.photographs
  end

  def test_curator_initializes_with_no_artists
    curator = Curator.new
    assert_equal [], curator.artists
  end

  def test_artists_can_be_added_to_curator
    @curator.add_artist(@artist_1)
    @curator.add_artist(@artist_2)

    assert_equal [@artist_1, @artist_2], @curator.artists
  end

  def test_curator_can_find_artist_by_id
    @curator.add_artist(@artist_1)
    @curator.add_artist(@artist_2)

    assert_equal @artist_1, @curator.find_artist_by_id("1")
  end

  def test_curator_can_find_photograph_by_id
    @curator.add_photograph(@photo_1)
    @curator.add_photograph(@photo_2)

    assert_equal @photo_2, @curator.find_photograph_by_id("2")
  end

  def test_it_can_find_all_photos_by_artist
    @curator.add_photograph(@photo_1)
    @curator.add_photograph(@photo_2)
    @curator.add_photograph(@photo_3)
    @curator.add_photograph(@photo_4)
    @curator.add_artist(@artist_1)
    @curator.add_artist(@artist_2)
    @curator.add_artist(@artist_3)

    assert_equal [@photo_3, @photo_4], @curator.find_photographs_by_artist(@artist_3)
  end

  def test_it_can_find_artists_with_multiple_photographs
    @curator.add_photograph(@photo_1)
    @curator.add_photograph(@photo_2)
    @curator.add_photograph(@photo_3)
    @curator.add_photograph(@photo_4)
    @curator.add_artist(@artist_1)
    @curator.add_artist(@artist_2)
    @curator.add_artist(@artist_3)

    assert_equal [@artist_3], @curator.artists_with_multiple_photographs
  end

  def test_curator_can_find_photos_taken_by_artists_from_a_country
    @curator.add_photograph(@photo_1)
    @curator.add_photograph(@photo_2)
    @curator.add_photograph(@photo_3)
    @curator.add_photograph(@photo_4)
    @curator.add_artist(@artist_1)
    @curator.add_artist(@artist_2)
    @curator.add_artist(@artist_3)

    assert_equal [@photo_2, @photo_3, @photo_4], @curator.photographs_taken_by_artist_from("United States")
    assert_equal [], @curator.photographs_taken_by_artist_from("Argentina")
  end

  def test_curator_can_load_photos_from_CSV
    @curator.load_photographs('./data/photographs.csv')

    assert_equal 4, @curator.photographs.length
    assert_instance_of Photograph, @curator.photographs.first
    assert_equal "Child with Toy Hand Grenade in Central Park", @curator.photographs.last.name
  end

  def test_curator_can_load_artists_from_CSV
    @curator.load_artists('./data/artists.csv')

    assert_equal 6, @curator.artists.length
    assert_instance_of Artist, @curator.artists.first
    assert_equal "Bill Cunningham", @curator.artists.last.name
  end

  def test_photos_taken_between
    @curator.load_photographs('./data/photographs.csv')
    @curator.load_artists('./data/artists.csv')

    assert_equal [@curator.photographs.first, @curator.photographs.last], @curator.photographs_taken_between(1950..1965)
  end

  def test_artists_photographs_by_age
    @curator.load_photographs('./data/photographs.csv')
    @curator.load_artists('./data/artists.csv')

    diane_arbus = @curator.find_artist_by_id("3")
    expected = {
      44=>"Identical Twins, Roselle, New Jersey",
      39=>"Child with Toy Hand Grenade in Central Park"
    }

    assert_equal expected, @curator.artists_photographs_by_age(diane_arbus)
  end
end
