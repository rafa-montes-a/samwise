class RemoveDateFromTouchpoints < ActiveRecord::Migration[6.0]
  def change
    remove_column :touchpoints, :date
  end
end
