class CreateMorningRoutines < ActiveRecord::Migration
  def change
    create_table :morning_routines do |t|
    	#Same as: t.integer "user_id"
    	t.references :user
    	t.integer "breakfast", :null => false, :default => 0
    	t.integer "shower", :null => false, :default => 0
    	t.integer "exercise", :null => false, :default => 0
    	t.integer "other", :null => false, :default => 0
      t.timestamps
    end
  end
end
