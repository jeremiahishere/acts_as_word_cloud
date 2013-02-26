class CreateSystem < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.integer :author_id
      t.string :title
      t.string :genre
      t.text :content

      t.timestamps
    end

    create_table :authors do |t|
      t.integer :publisher_id
      t.string :name
      t.text :biography
      
      t.timestamps
    end

    create_table :publishers do |t|
      t.string :name
      t.string :location
      
      t.timestamps
    end
    
    create_table :readers do |t|
      t.string :name
      t.integer :age
      
      t.timestamps
    end
   
    create_table :article_readers do |t|
      t.integer :article_id
      t.integer :reader_id
    end
  end
end
