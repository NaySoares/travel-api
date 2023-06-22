require "kemal"
require "json"
require "random"
require "./CreateTravelPlanUseCase"

class CreateTravelPlanController < Kemal::Handler
  post "/travel_plans" do |context|
    context.response.content_type = "application/json"
    travel_stops = context.params.json["travel_stops"].as(Array)

    travel_stops.each { |element| 
      if element.as_i64 < 1 || element.as_i64 > 126
        error = {message: "Elements of travel_stops must be between 1 and 126"}.to_json
        halt context, status_code: 403, response: error
      end
    }
    
    if !travel_stops
      error = {message: "travel_stops is required"}.to_json
      halt context, status_code: 403, response: error
    end

    travel_plan = CreateTravelPlanUseCase.execute(travel_stops)

    halt context, status_code: 201, response: travel_plan.to_json
  end
end
