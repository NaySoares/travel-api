require "kemal"
require "json"
require "./GetTravelPlanByIdUseCase"

class GetTravelPlanByIdController < Kemal::Handler
  get "/travel_plans/:id" do |context|
    context.response.content_type = "application/json"
    id = context.params.url["id"]

    id_as_number = nil

    try do
      id_as_number = id.to_i64
    rescue
      error = {message: "id is required and must be a number"}
      halt context, status_code: 403, response: error.to_json
    end

    travel_plans = GetTravelPlanByIdUseCase.execute(id)

    halt context, status_code: 200, response: travel_plans.to_json
  end
end
