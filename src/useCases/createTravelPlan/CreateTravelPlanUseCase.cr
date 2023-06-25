require "../../db/*"
require "../../utils/RequestClient"
require "json"

class CreateTravelPlanUseCase 
  def self.execute(travelStops)
    response = RestClient.getLocation("1")
    res_json = JSON.parse(response.body)

    if response.status_code != 200
      puts "Error while getting location"
      return
    end

    name = res_json["name"]
    type = res_json["type"]
    dimension = res_json["dimension"]

    db = DatabaseManager.connection
    try do
      db.exec("INSERT INTO travels (travel_stops, name, type, dimension) VALUES ($1, $2, $3, $4)", travelStops, name, type, dimension) 
    rescue e    
      puts "Error while creating travel plan: #{e}"
    end

    id = nil 

    try do
      db.query ("SELECT * FROM travels ORDER BY id DESC LIMIT 1;") do |result|
        result.each do
          id = result.read(Int32)
        end
      end
    rescue e
      puts "Error while getting travel plan id: #{e}"
    end

    return travel_plan = {
      "id": id,
      "travel_stops": travelStops
    }

    db.close
  end
end