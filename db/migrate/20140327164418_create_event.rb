class CreateEvent < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.column :description, :string
      t.column :location, :string
      t.column :start, :datetime
      t.column :end, :datetime

      t.timestamps
    end
      create_table :calendar_date do |t|
        t.column :name, :string
        t.column :event_id, :int

        t.timestamps
    end
  end
end
