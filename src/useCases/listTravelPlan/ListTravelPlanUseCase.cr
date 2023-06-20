require "../../db/*"


class ListTravelPlanController 
  def self.execute() 
    db = DatabaseManager.connection
    list_travel_plans = nil

    try do
      response = db.query ("SELECT * FROM travels")
        
      return response
      
    rescue e    
      puts "Error while listing travel plans: #{e}"
    end

    db.close
  end
end