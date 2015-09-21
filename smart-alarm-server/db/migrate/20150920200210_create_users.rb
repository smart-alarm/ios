class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
			t.string "email", :null => false, :limit => 30
    	t.string "password_digest"
      t.timestamps
    end
  end
end
