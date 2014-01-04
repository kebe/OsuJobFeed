class CreateJobListings < ActiveRecord::Migration
  def change
    create_table :job_listings do |t|
      t.integer :entry_id
      t.datetime :published
      t.datetime :updated
      t.string :link
      t.string :title
      t.text :content
      t.string :department

      t.timestamps
    end
  end
end
