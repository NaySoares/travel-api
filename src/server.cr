require "crystal-env"
require "kemal"
require "./controllers/travel_plan_controller"
require "db"
require "pg"
require "crystal-env"

DB.open("postgres://axios:docker@localhost:5432/milenio-api_development") do |db|
   
end

Kemal.run