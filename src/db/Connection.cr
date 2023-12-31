require "db"
require "pg" 

class DatabaseManager
  @@connection : DB::Database = DB.open("postgres://axios:docker@localhost:5432/milenio-api_development")

  def self.connection : DB::Database
    @@connection
  end

  def self.setup
    conn = connection

    conn.exec("CREATE TABLE IF NOT EXISTS travels (id SERIAL PRIMARY KEY, travel_stops INTEGER[], name TEXT, type TEXT, dimension TEXT, created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP, updated_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP);")
  end
end