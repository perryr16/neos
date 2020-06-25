mkdrequire 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require_relative 'near_earth_objects'

class NearEarthObjectsTest < Minitest::Test
  def setup
    @date = "2020-05-23"

  end
  def test_a_date_returns_a_list_of_neos
    results = NearEarthObjects.find_neos_by_date('2019-03-30')
    assert_equal '(2019 GD4)', results[:asteroid_list][0][:name]
  end

  def test_faraday_returns_api
    conn = NearEarthObjects.conn(@date)
    assert_equal Faraday::Connection, conn.class
    
    expected = {"start_date"=>"2020-05-23", "api_key"=>"ijXMptaieQVobOnuvExAPcxEhzCgCQjhYwJbF5X3"}
    assert_equal expected, conn.params
  end
  
  def test_data_is_parsed_as_hash
    results = NearEarthObjects.parsed_asteroids_data(@date)
    assert_equal Array, results.class
    assert_equal Hash, results.first.class
    assert_equal Hash, results.last.class
    assert_equal Symbol, results.last.keys.first.class
  end

  def test_largest_asteroids_diameter
    raw = NearEarthObjects.parsed_asteroids_data(@date)[6][:estimated_diameter][:feet][:estimated_diameter_max].to_i
    results = NearEarthObjects.largest_asteroid_diameter(@date)
    assert_equal raw, results
  end

  def test_returns_number_of_asteroids_on_date
    results = NearEarthObjects.total_number_of_asteroids(@date)
    assert_equal 11, results
  end

  def test_formatted_asteroid_data
    results = NearEarthObjects.formatted_asteroid_data(@date)
    assert_equal :name, results.first.keys[0]
    assert_equal :diameter, results.first.keys[1]
    assert_equal :miss_distance, results.first.keys[2]
    assert_equal 11, results.count
    assert_equal "141052 (2001 XR1)", results[6][:name]
    assert_equal "6456 ft", results[6][:diameter]
    assert_equal "44906608 miles", results[6][:miss_distance]
  end

  def test_find_neos_by_date
    results = NearEarthObjects.find_neos_by_date(@date)
    assert_equal 11, results[:asteroid_list].count 
    assert_equal "(2020 KB1)", results[:asteroid_list][0][:name] 
    assert_equal 6456, results[:biggest_asteroid]
    assert_equal 11, results[:total_number_of_asteroids]
  end
  
  
  
  
  
  
end
