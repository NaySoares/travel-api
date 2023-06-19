require "db"
require "pg" 

class DatabaseManager
  @@connection : DB::Database = DB.open("postgres://axios:docker@localhost:5432/milenio-api_development")

  def self.connection : DB::Database
    @@connection
  end

  def self.setup
    conn = connection

    conn.exec("CREATE TABLE IF NOT EXISTS travels (id SERIAL PRIMARY KEY, travel_stops INTEGER[], created_at timestamp NOT NULL, updated_at timestamp NOT NULL);")
  end
end