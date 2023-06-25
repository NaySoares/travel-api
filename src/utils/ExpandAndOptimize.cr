require "json"
require "./RequestClient"

abstract struct StopPoint
  include JSON::Serializable
end

struct Stops < StopPoint
  getter id, name, type, dimension, residents
  def initialize(@id : Int32, @name : String, @type : String, @dimension : String, @residents : Array(String));
  end
end

struct StopsWithoutResidents < StopPoint
  getter id, name, type, dimension
  def initialize(@id : Int32, @name : String, @type : String, @dimension : String);
  end
end


class ExpandAndOptimize
  def self.removeResidents(stops)
    # remove residents for adequate response by requirement
    stops.map do |stop|
      stop = {
        id: stop.id,
        name: stop.name,
        type: stop.type,
        dimension: stop.dimension
      }
    end
  end

  def self.expand(travel_stops)
    travel_stops.map do |stop|
      response = GraphqlClient.get(stop, 0)
  
      name = response["data"]["location"]["name"].as_s
      type = response["data"]["location"]["type"].as_s
      dimension = response["data"]["location"]["dimension"].as_s
  
      residents = response["data"]["location"]["residents"].as_a.map do |resident|
        resident["id"].as_s
      end
      
      Stops.new(stop, name, type, dimension, residents)
    end
  end
  
  def self.popularity(stops)
    popularity_local = Hash(String, Float64).new
    popularity_dimension = Hash(String, Float64).new
    count_dimension = Hash(String, Int32).new
  
    stops.map do |stop|
      if popularity_dimension.has_key?(stop.dimension)
        count_dimension[stop.dimension] = count_dimension[stop.dimension] + 1
      else
        count_dimension[stop.dimension] = 1
        popularity_dimension[stop.dimension] = 0
      end
  
      if !popularity_local.has_key?(stop.name)
        popularity_local[stop.name] = 0
      end
  
      stop.residents.map do |resident|
        response = GraphqlClient.get(0, resident)
        response["data"]["character"]["episode"].as_a.map do |episode|
          popularity_local[stop.name] += 1
          popularity_dimension[stop.dimension] += 1
        end
      end
    end
    
    count_dimension.map do |key, value|
      if count_dimension[key] > 1 
        popularity_dimension[key] = popularity_dimension[key] / value
      end
    end
  
    stops_sorted = arrayGroupByDimension(stops, popularity_dimension)
    # this sort only works if the stops are already sorted by dimension
    stops_super_sorted = sortSubArrayByLocal(stops_sorted, popularity_local)
  
    return stops_super_sorted
  end
  
  def self.sortSubArrayByLocal(stops : Array(Stops), popularity : Hash(String, Float64)) : Array(Stops)
    dimension_groups = Hash(String, Array(Stops)).new
    
    stops.each do |stop|
      dimension = stop.dimension
  
      if dimension_groups.has_key?(dimension)
        dimension_groups[dimension] << stop
      else
        dimension_groups[dimension] = [stop]
      end
    end
    
    sorted_stops = Array(Stops).new
    
    dimension_groups.each_value do |stops_in_dimension|
      sorted_stops += arrayGroupByLocal(stops_in_dimension, popularity)
    end
    
    return sorted_stops
  end
  
  def self.arrayGroupByDimension(stops : Array(Stops), popularity : Hash(String, Float64)) : Array(Stops)
    stops_sorted = stops.sort_by { |stop| popularity[stop.dimension] }
    return stops_sorted
  end
  
  def self.arrayGroupByLocal(stops : Array(Stops), popularity : Hash(String, Float64)) : Array(Stops)
    stops_sorted = stops.sort_by { |stop| popularity[stop.name] }
    return stops_sorted
  end
  
  def self.popularityRank(residents)
    popularity = 0
  
    residents.map do |resident|
      response = GraphqlClient.get(0, resident)
      response["data"]["character"]["episode"].as_a.map do |episode|
        popularity += 1
      end
    end
  
    return popularity
  end

end