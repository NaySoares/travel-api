require "crystal-env"
require "kemal"
require "./controllers/*"
require "./db/*"

DatabaseManager.setup

Kemal.run