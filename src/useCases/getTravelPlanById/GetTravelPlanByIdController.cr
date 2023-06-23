require "kemal"
require "json"
require "./GetTravelPlanByIdUseCase"

class GetTravelPlanByIdController < Kemal::Handler
  get "/travel_plans/:id" do |context|
    context.response.content_type = "application/json"
    optimize = context.params.query["optimize"]? 
    expand = context.params.query["expand"]? 
    id = 0
    error = nil

    try do 
      id = context.params.url["id"].to_i32
    rescue
      error = {message: "id is required and must be a number"}
      halt context, status_code: 403, response: error.to_json
    end

    next if error

    travel_plans = GetTravelPlanByIdUseCase.execute(id, expand, optimize)

    if travel_plans == 404
      error = {message: "Travel plan not found"}
      halt context, status_code: 404, response: error.to_json
    end

    halt context, status_code: 200, response: travel_plans.to_json
  end
end
