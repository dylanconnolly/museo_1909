require 'minitest/autorun'
require 'minitest/pride'
require './lib/photograph'
require './lib/artist'
require './lib/curator'

class CuratorTest < Minitest::Test

  def setup
    @curator = Curator.new
  end

  def test_it_exists
    assert_instance_of Curator, @curator
  end

  def test_it_initializes_with_no_photographs
    curator = Curator.new
    assert_equal [], curator.photographs
  end

end
