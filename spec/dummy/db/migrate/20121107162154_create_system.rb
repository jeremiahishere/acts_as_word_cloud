class CreateSystem < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.integer :author_id
      t.integer :publisher_id
      t.integer :site_id
      t.string :title
      t.string :genre
      t.text :content

      t.timestamps
    end
    add_index :articles, :author_id
    add_index :articles, :publisher_id
    add_index :articles, :site_id

    create_table :authors do |t|
      t.integer :publisher_id
      t.integer :site_id
      t.string :name
      t.string :genre
      t.integer :age
      
      t.timestamps
    end
    add_index :authors, :publisher_id
    add_index :authors, :site_id

    create_table :publishers do |t|
      t.string :name
      t.string :location
      
      t.timestamps
    end
    
    create_table :readers do |t|
      t.integer :site_id
      t.string :username
      t.integer :age
      
      t.timestamps
    end
    add_index :readers, :site_id
   
    create_table :followings do |t|
      t.string :special_name
      t.integer :article_id
      t.integer :reader_id
    end
    add_index :followings, :article_id
    add_index :followings, :reader_id
    
    create_table :sites do |t|
      t.integer :publisher_id 
      t.string :name
      t.string :domain
      t.string :genre

      t.timestamps
    end
    add_index :sites, :publisher_id

  end
end
