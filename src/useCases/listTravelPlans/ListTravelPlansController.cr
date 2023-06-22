require "kemal"
require "json"
require "./ListTravelPlansUseCase"

class ListTravelPlansController < Kemal::Handler
  get "/travel_plans" do |context|
    context.response.content_type = "application/json"
    optimize = context.params.query["optimize"]? 
    expand = context.params.query["expand"]? 

    list_travel_plans = ListTravelPlansUseCase.execute(optimize, expand)

    halt context, status_code: 200, response: list_travel_plans.to_json
  end
end
