require "../../db/*"
require "json"

alias Id = Int64

abstract struct StopPoint
  include JSON::Serializable
end

struct TravelStop < StopPoint
  getter id, travel_stops
  def initialize(@id : Id, @travel_stops : Array(Int32)); end
end

class ListTravelPlanController 
  def self.execute() 
    db = DatabaseManager.connection
    list_travel_plans = Array(TravelStop).new
    
    db.query "SELECT id, travel_stops FROM travels ORDER BY id DESC" do |rs|
      try do
        rs.each do 
          id = rs.read(Int64)
          travel_stops = rs.read(Array(Int32))

          result = TravelStop.new(id, travel_stops)
      
          list_travel_plans.push(result)
        end
      rescue e
        puts "Error while listing travel plans: #{e}"
      end
    end
    db.close
    return list_travel_plans
  
  end
end