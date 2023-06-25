require "../../db/*"
require "../../utils/ExpandAndOptimize"

class GetTravelPlanByIdUseCase 
  def self.execute(id, expand = false, optimize = false) 
    db = DatabaseManager.connection
    try do
      db.query("SELECT id, travel_stops FROM travels WHERE id = $1", id) do |rs|
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

            return travel_plan = {
              id: id,
              travel_stops: sorted_ids
            }
          end

          if expand
            stops = Array(Stops).new
            stops = ExpandAndOptimize.expand(travel_stops)

            if optimize
              sorted_stops = ExpandAndOptimize.popularity(stops)
              sorted_stops = ExpandAndOptimize.removeResidents(sorted_stops)
              return travel_plan = {
                id: id,
                travel_stops: sorted_stops
              }
            end
            
            stops = ExpandAndOptimize.removeResidents(stops)
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
