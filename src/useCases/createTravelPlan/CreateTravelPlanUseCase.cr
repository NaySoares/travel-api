require "../../db/*"

class CreateTravelPlanUseCase 
  def self.execute(id, travelStops) 
    db = DatabaseManager.connection
    try do
      db.exec ("INSERT INTO travels (id, travel_stops) VALUES (#{id}, ARRAY#{travelStops})")

      return travel_plan = {
        "id" => id,
        "travel_stops" => travelStops
      }
    rescue e    
      puts "Error while creating travel plan: #{e}"
    end

    db.close
  end
end