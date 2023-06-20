require "kemal"
require "json"
require "random"
require "./CreateTravelPlanUseCase"

class TravelPlanController < Kemal::Handler
  post "/travel_plans" do |context|
    context.response.content_type = "application/json"
    travel_stops = context.params.json["travel_stops"].as(Array)
    
    if !travel_stops
      error = {message: "travel_stops is required"}.to_json
      halt context, status_code: 403, response: error
    end

    r = Random.new
    id = r.next_u

    travel_plan = CreateTravelPlanUseCase.execute(id, travel_stops)

    halt context, status_code: 201, response: travel_plan.to_json
  end

  post "/travel-plans/:id" do |context|
    id = context.params.url["id"]
    travel_stops = context.params.json["travel_stops"].as(Array)

    id_as_number = nil

    try do
      id_as_number = id.to_i
    rescue
      error = {message: "id is required and must be a number"}.to_json
      halt context, status_code: 403, response: error
    end
    
    if !travel_stops
      error = {message: "travel_stops is required"}.to_json
      halt context, status_code: 403, response: error
    end

    travel_plan = {
      "id" => id_as_number,
      "travel_stops" => travel_stops
    }.to_json

    halt context, status_code: 201, response: travel_plan

  end
end
