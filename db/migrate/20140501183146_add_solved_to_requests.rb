class AddSolvedToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :solved, :boolean
  end
end
