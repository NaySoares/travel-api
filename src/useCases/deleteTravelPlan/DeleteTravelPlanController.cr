require "kemal"
require "json"
require "./DeleteTravelPlanUseCase"

class DeleteTravelPlanController < Kemal::Handler
  delete "/travel_plans/:id" do |context|
    context.response.content_type = "application/json"
    id = context.params.url["id"]

    id_as_number = nil

    try do
      id_as_number = id.to_i64
    rescue
      error = {message: "id is required and must be a number"}
      halt context, status_code: 403, response: error.to_json
    end
    
    checked_delete_result = DeleteTravelPlanUseCase.execute(id)

    if checked_delete_result === (nil || false)
      halt context, status_code: 403, response: "error deleting travel plan".to_json
    end
    halt context, status_code: 204

  end
end
