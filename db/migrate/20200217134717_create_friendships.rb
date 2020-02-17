class CreateFriendships < ActiveRecord::Migration[5.2]
  def change
    create_table :friendships do |t|
      t.references :creator, foreign_key: { to_table: :users }
      t.references :friend, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :friendships, [:creator_id, :friend_id], unique: true
  end
end
