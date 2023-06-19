require "jennifer"
require "jennifer/adapter/postgres"

require "./src/config/initializers/*"
require "./src/db/migrations/*"
require "sam"
require "jennifer/sam"
load_dependencies "jennifer"
Sam.help