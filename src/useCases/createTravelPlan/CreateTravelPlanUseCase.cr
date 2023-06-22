require "../../db/*"
require "../../utils/*"
require "json"

class CreateTravelPlanUseCase 
  def self.execute(id, travelStops)
    response = RestClient.getLocation("1")
    res_json = JSON.parse(response.body)

    if response.status_code != 200
      puts "Error while getting location"
      return
    end
    
    db = DatabaseManager.connection
    try do
      db.exec ("INSERT INTO travels (id, travel_stops, name, type, dimension) VALUES (#{id}, ARRAY#{travelStops}, #{res_json["name"]}, #{res_json["type"]}, #{res_json["dimension"]})")

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