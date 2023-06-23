require "../../db/*"
require "../../utils/*"
require "json"

abstract struct StopPoint
  include JSON::Serializable
end

struct Stops < StopPoint
  getter id, name, type, dimension
  def initialize(@id : Int32, @name : String, @type : String, @dimension : String);
  end
end

class GetTravelPlanByIdUseCase 
  def self.execute(id, expand = false, optimize = false) 
    db = DatabaseManager.connection
    try do
      db.query "SELECT id, travel_stops FROM travels WHERE id = #{id}" do |rs|
        rs.each do 
          id = rs.read(Int32)
          travel_stops = rs.read(Array(Int32))

          if expand
            stops = Array(Stops).new
            
            travel_stops = travel_stops.map do |stop|
              response = GraphqlClient.get(stop, 0)

              name = response["data"]["location"]["name"].as_s
              type = response["data"]["location"]["type"].as_s
              dimension = response["data"]["location"]["dimension"].as_s
              
              result = Stops.new(stop, name, type, dimension)

              stops.push(result)
            end

            return travel_plan = {
              id: id,
              travel_stops: stops
            }
          end

          return travel_plan = {
            id: id,
            travel_stops: travel_stops
          }
        end
      end
    rescue e
      puts "Error while listing travel plans: #{e}"
    end

    db.close
    
    return 404
  end
end