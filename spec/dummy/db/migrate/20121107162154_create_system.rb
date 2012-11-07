class CreateSystem < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.integer :article_id
      t.integer :author_id
      t.integer :publisher_id
      t.integer :site_id
      t.string :title
      t.string :genre
      t.text :content

      t.timestamps
    end

    create_table :authors do |t|
      t.integer :author_id
      t.string :name
      t.string :genre
      t.integer :age
      
      t.timestamps
    end

    create_table :publishers do |t|
      t.integer :publisher_id
      t.string :name
      t.string :location
      
      t.timestamps
    end
    
    create_table :readers do |t|
      t.integer :reader_id
      t.string :username
      t.string :age
      
      t.timestamps
    end
    
    create_table :site do |t|
      t.integer :site_id
      t.string :name
      t.string :domain
      t.string :genre

      t.timestamps
    end

  end
end
