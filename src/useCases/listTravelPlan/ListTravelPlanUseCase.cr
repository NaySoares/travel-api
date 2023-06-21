require "../../db/*"


class ListTravelPlanController 
   struct TravelStop
    property id : Int64
    property travel_stops : Array(Int32)

    def initialize(@id : Int64, @travel_stops : Array(Int32))
    end
  end

  def self.execute() 
    db = DatabaseManager.connection
    list_travel_plans = Array(TravelStop).new
    db.query "SELECT id, travel_stops FROM travels ORDER BY id DESC" do |rs|
      rs.each do 
        id = rs.read(Int64)
        travel_stops = rs.read(Array(Int32))
        list_travel_plans << TravelStop.new(id, travel_stops)

      end
    end
    return list_travel_plans.to_s
    
    #rescue e    
    #  puts "Error while listing travel plans: #{e}"
    #end

    db.close
  end
end