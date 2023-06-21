require "kemal"
require "json"
require "./UpdateTravelPlanController"

class TravelPlanController < Kemal::Handler
  put "/travel_plans/:id" do |context|
    context.response.content_type = "application/json"
    id = context.params.url["id"]
    travel_stops = context.params.json["travel_stops"].as(Array)

    id_as_number = nil

    try do
      id_as_number = id.to_i
    rescue
      error = {message: "id is required and must be a number"}
      halt context, status_code: 403, response: error.to_json
    end
    
    if !travel_stops
      error = {message: "travel_stops is required"}
      halt context, status_code: 403, response: error.to_json
    end

    travel_plan_updated = UpdateTravelPlanUseCase.execute(id, travel_stops)

    halt context, status_code: 200, response: travel_plan_updated.to_json

  end
end
