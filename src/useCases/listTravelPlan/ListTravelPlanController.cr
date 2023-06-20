require "kemal"
require "json"
require "./ListTravelPlanController"

class TravelPlanController < Kemal::Handler
  get "/travel_plans" do |context|
    context.response.content_type = "application/json"

    list_travel_plans = ListTravelPlanController.execute()

    halt context, status_code: 201, response: list_travel_plans.to_json
  end
end
