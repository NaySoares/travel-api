require "../../db/*"

class UpdateTravelPlanUseCase
  def self.execute(id, travelStops) 
    db = DatabaseManager.connection
    try do
      db.exec ("UPDATE travels SET travel_stops = Array#{travelStops} WHERE id = #{id}")

      return travel_plan = {
        "id" => id,
        "travel_stops" => travelStops
      }
    rescue e    
      puts "Error while updating travel plan: #{e}"
    end

    db.close
  end
end