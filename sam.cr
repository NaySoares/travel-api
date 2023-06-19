require "jennifer"
require "jennifer/adapter/postgres"

require "./config/initializers/*"
require "./src/db/migrations/*"
require "sam"
require "jennifer/sam"
load_dependencies "jennifer"
Sam.help