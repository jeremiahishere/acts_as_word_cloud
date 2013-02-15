require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "ActsAsWordCloud" do
  before(:all) do
    @lone_article = Article.make
    @publisher = Publisher.make(:name => "publisher", :location => "location")
    @site = Site.make( :name => "site name", :domain => "uff.us", :genre => "site genre", :publisher => @publisher)
    @author = Author.make(:name => "author", :genre => "author genre", :publisher => @publisher, :site => @site)
    @article = Article.make(:title => "article title", :genre => "genre", :content => "article text", :author => @author, :publisher => @publisher, :site => @site) 
    @reader = Reader.make(:username => "reader", :site => @site)
    @following = Following.make(:article => @article, :reader => @reader, :special_name => "following1")
  end
  
  describe "word_cloud" do
    describe "class method use_word_cloud" do
      it "should contain set or default values in attributes" do
        @article.word_cloud_using.should == [:title]
        @article.word_cloud_excluded.should == []
        @article.word_cloud_depth.should == 1
        @article.word_cloud_no_mixin_fields.should == [:name, :title, :label]
      end
    end

    it "should return the right association models" do
      @lone_article.word_cloud.should == [@lone_article.title, @lone_article.genre, @lone_article.content, @lone_article.author.name, @lone_article.publisher.name, @lone_article.site.domain ] 
      @article.word_cloud.should == [@article.title, @article.genre, @article.content, @article.author.name, @article.publisher.name, @article.site.domain, @article.readers.first.username, "Following" ] 
      
      @publisher2 = Publisher.make(:name => "publisher2", :location => "location2")
      @site2 = Site.make( :name => "site2 name", :domain => "uff.us2", :genre => "site2 genre", :publisher => @publisher2)
      @author2 = Author.make(:name => "author2", :genre => "author2 genre", :publisher => @publisher2, :site => @site2)
      @article2 = Article.make(:title => "article2 title", :genre => "genre2", :content => "article2 text", :author => @author2, :publisher => @publisher2, :site => @site2) 
      @following2 = Following.make(:article => @article2, :reader => @reader , :special_name => "following2")
      
      @reader.word_cloud(2).should == [@reader.username, @reader.site.domain, @article.title, @article2.title, "Following", @site.name, @site.genre, @site.publisher.name, @site.authors.first.name, @article.genre, @article.content, @article2.genre, @article2.content, @article2.author.name, @article2.publisher.name, @article2.site.domain ]
    end
  end
  
  describe "instance methods:" do
    describe "word_cloud_associated_objects" do
      it "should return correct models when called with belongs_to" do
        @article.word_cloud_associated_objects(:belongs_to).should == [@article.author, @article.publisher, @article.site]
      end
      
      it "should return correct models when called with has_many" do
        @article.word_cloud_associated_objects(:has_many).should == [@article.followings, @article.readers]
      end
    end 
    
    describe "word_cloud_get_associated" do   
      it "should return collectoin of non-nil associated models" do
        @article.word_cloud_get_associated(:belongs_to).should == [:author, :publisher, :site]
        @lone_article.word_cloud_get_associated(:has_many).should == []
        @article.word_cloud_get_associated(:has_many).should == [:followings, :readers]
      end
    end
 
    describe "word_cloud_exclude_words" do
      it "should not keep excluded models" do
        @article.stub!(:word_cloud_excluded).and_return([Publisher])
        objects = @article.word_cloud_associated_objects(:belongs_to) 
        @article.word_cloud_exclude_words(objects).should == [@article.author, @article.site]
      end 
    end
    
    describe "word_cloud_no_mixin" do
      it "should only have models that don't have the mixin" do
        objects = @article.word_cloud_associated_objects(:has_many) 
        @article.word_cloud_no_mixin(objects).should == @article.followings
      end 
    end
     
    describe "word_cloud_process_words" do
      it "should return result of first included method to work on objects with mixin" do
        objects = []
        objects += @article.word_cloud_associated_objects(:belongs_to) 
        objects += @article.word_cloud_associated_objects(:has_many) 
        objects = @article.word_cloud_exclude_words(objects)
        no_mixin = @article.word_cloud_no_mixin(objects)
        objects -= no_mixin
        @article.word_cloud_process_words(objects).should == [@article.author.name, @article.publisher.name, @article.site.domain, @article.readers.first.username]
      end
    end

    describe "word_cloud_apply_fields_to" do
      it "return the value found in the first method to work on object passed in, if there's none return class name" do
        @article.word_cloud_apply_fields_to(@article.followings.first).should == "Following"
        @article.stub!(:word_cloud_no_mixin_fields).and_return([:special_name])
        @article.word_cloud_apply_fields_to(@article.followings.first).should == @article.followings.first.special_name
      end
    end

    describe "word_cloud_find_field" do
      it "should return result of first included method to work on objects with mixin or their class names" do
        @article.word_cloud_find_field(@article.followings).should == ["Following"]
      end
    end

    describe "word_cloud_get_valid_strings" do
      it "should return used methods on model and string attributes not in skipped list" do
        @article.stub!(:word_cloud_skipped).and_return([:title, :content])
        @article.word_cloud_get_valid_strings.should_not include "article title"
        @article.word_cloud_get_valid_strings.should_not include "article text"
        @article.word_cloud_get_valid_strings.should include "genre"
      end
    end
  
  end
end

