require "crystal-env"
require "kemal"
require "./useCases/*"
require "./db/*"

DatabaseManager.setup

Kemal.run