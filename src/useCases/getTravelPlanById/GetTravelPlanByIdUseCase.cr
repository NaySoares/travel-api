require "../../db/*"
require "json"

class GetTravelPlanByIdUseCase 
  def self.execute(id) 
    db = DatabaseManager.connection
    try do
      db.query "SELECT id, travel_stops FROM travels WHERE id = #{id}" do |rs|
        rs.each do 
          id = rs.read(Int32)
          travel_stops = rs.read(Array(Int32))

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