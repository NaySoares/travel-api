require "../../db/*"
require "../../utils/ExpandAndOptimize"

struct TravelStop < StopPoint
  getter id, travel_stops
  def initialize(@id : Int32, @travel_stops : Array(Int32)); end
end

struct TravelPlanExpanded < StopPoint
  getter id, travel_stops
  def initialize(@id : Int32, @travel_stops : Array(Stops)); 
  end
end

class ListTravelPlansUseCase 
  def self.execute(optimize = false, expand = false)
    db = DatabaseManager.connection
    list_travel_plans = Array(TravelStop).new
    list_travel_plans_special = Array(TravelPlanExpanded).new
    

    try do
      db.query "SELECT id, travel_stops FROM travels ORDER BY id DESC" do |rs|
        rs.each do 
          id = rs.read(Int32)
          travel_stops = rs.read(Array(Int32))

          if (optimize) && (!expand)
            stops = Array(Stops).new
            stops = ExpandAndOptimize.expand(travel_stops)
            sorted_stops = ExpandAndOptimize.popularity(stops)
            sorted_ids = sorted_stops.map do |stop|
              stop.id
            end

            results = TravelStop.new(id, travel_stops)
            list_travel_plans.push(results)
            next
          end
          
          if expand
            stops = Array(Stops).new
            stops = ExpandAndOptimize.expand(travel_stops) 

            if optimize
              sorted_stops = ExpandAndOptimize.popularity(stops)
              travel_plan = TravelPlanExpanded.new(id, sorted_stops)
              list_travel_plans_special.push(travel_plan)
              next
            end
            
            travel_plan = TravelPlanExpanded.new(id, stops)
            list_travel_plans_special.push(travel_plan)
            next
          end

          result = TravelStop.new(id, travel_stops)
          list_travel_plans.push(result)
        end
      end
    rescue e
      puts "Error while listing travel plans: #{e}"
    end
    db.close
    
    if (optimize) && (!expand)
      return list_travel_plans
    end

    if expand || optimize
      return list_travel_plans_special
    end

    return list_travel_plans
  end
end