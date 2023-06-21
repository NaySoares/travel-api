require "../../db/*"

class DeleteTravelPlanUseCase
  def self.execute(id) 
    db = DatabaseManager.connection
    try do
      db.exec ("DELETE FROM travels WHERE id = #{id}")

      return true
    rescue e    
      puts "Error deleting travel plan: #{e}"
    end

    db.close
  end
end