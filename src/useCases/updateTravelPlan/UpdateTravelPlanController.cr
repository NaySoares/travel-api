require "kemal"
require "json"
require "./UpdateTravelPlanController"
require "../getTravelPlanById/GetTravelPlanByIdUseCase"

class UpdateTravelPlanController < Kemal::Handler
  put "/travel_plans/:id" do |context|
    context.response.content_type = "application/json"
    travel_stops = context.params.json["travel_stops"].as(Array)
    id = 0

    try do 
      id = context.params.url["id"].to_i32
    rescue
      error = {message: "id is required and must be a number"}
      halt context, status_code: 403, response: error.to_json
    end
    
    if !travel_stops
      error = {message: "travel_stops is required"}
      halt context, status_code: 403, response: error.to_json
    end

    travel_plan_exists = GetTravelPlanByIdUseCase.execute(id)

    if travel_plan_exists == 404
      error = {message: "Travel plan not found"}
      halt context, status_code: 404, response: error.to_json
    end

    travel_plan_updated = UpdateTravelPlanUseCase.execute(id, travel_stops)

    halt context, status_code: 200, response: travel_plan_updated.to_json

  end
end
