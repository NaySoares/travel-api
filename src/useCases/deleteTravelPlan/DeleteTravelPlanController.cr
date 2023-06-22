require "kemal"
require "json"
require "./DeleteTravelPlanUseCase"
require "../getTravelPlanById/GetTravelPlanByIdUseCase"

class DeleteTravelPlanController < Kemal::Handler
  delete "/travel_plans/:id" do |context|
    context.response.content_type = "application/json"
    id = 0

    try do 
      id = context.params.url["id"].to_i32
    rescue
      error = {message: "id is required and must be a number"}
      halt context, status_code: 403, response: error.to_json
    end

    travel_plan_exists = GetTravelPlanByIdUseCase.execute(id)

    if travel_plan_exists == 404
      error = {message: "Travel plan not found"}
      halt context, status_code: 404, response: error.to_json
    end
    
    DeleteTravelPlanUseCase.execute(id)

    halt context, status_code: 204

  end
end
