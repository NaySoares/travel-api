require "jennifer"

class TravelPlans < Jennifer::Model::Base
  with_timestamps
  mapping(
    id: {type: Int32, primary: true},
    travel_plans: {type: Array(Int32)},
    created_at: {type: Time, null: true},
    updated_at: {type: Time, null: true}
  )
end