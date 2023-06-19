class TravelPlans < Jennifer::Migration::Base
  def up
    create_table(:travels) do |t|
      t.integer :travel_plans, {:array => true}
      t.timestamps
    end
  end

  def down
    drop_table :travels
  end
end
