require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Integration tests" do
  describe "mixin" do
    it "should set default values if called with no arguments" do
      reader = Reader.new
      reader.word_cloud_attributes[:included_methods].should == []
      reader.word_cloud_attributes[:excluded_methods].should == []
      reader.word_cloud_attributes[:excluded_models].should == []
      reader.word_cloud_attributes[:depth].should == ActsAsWordCloud.config.default_search_depth
      reader.word_cloud_attributes[:object_name_methods].should == ActsAsWordCloud.config.object_name_methods
    end

    it "should set attributes included in the mixin call" do
      article = Article.new
      article.word_cloud_attributes[:included_methods].should == [:truncated_title]
      article.word_cloud_attributes[:excluded_methods].should == [:genre]
      article.word_cloud_attributes[:excluded_models].should == [ArticleReader, Reader]
      article.word_cloud_attributes[:depth].should == 2
      article.word_cloud_attributes[:object_name_methods].should == [:title]
    end
  end

  describe "included methods" do
    before(:each) do
      @publisher = Publisher.make(:name => "Cloudhouse")
      @author = Author.make(:publisher => @publisher, :name => "Jeremiah Hemphill")
      @article = Article.make(:author => @author)

      @word_cloud_output = @article.word_cloud(:array)
    end

    it "should return database attributes" do
      expected_word_cloud_output = [
        @article.title,
        @article.content
      ]
      expected_word_cloud_output.each do |str|
        @word_cloud_output.should include str
      end
    end
    
    it "should return associated object names" do
      expected_word_cloud_output = [
        @author.name,
        @publisher.name,
      ]
      expected_word_cloud_output.each do |str|
        @word_cloud_output.should include str
      end
    end

    it "should return included methods" do
      expected_word_cloud_output = [
        @article.truncated_title
      ]
      expected_word_cloud_output.each do |str|
        @word_cloud_output.should include str
      end
    end
  end

  describe "excluded methods" do
    before(:each) do
      @article = Article.make
      @word_cloud_output = @article.word_cloud(:array)
    end

    it "should not include database attributes in excluded methods" do
      @word_cloud_output.should_not include @article.genre
    end
  end

  describe "excluded_models" do
    before(:each) do
      @article = Article.make
      @reader = Reader.make(:name => "Alfredo Uribe")
      @article_reader = ArticleReader.make(:article => @article, :reader => @reader)
      @word_cloud_output = @article.word_cloud(:array)
    end

    it "should not include excluded models with an association to the current model" do
      @word_cloud_output.should_not include @article_reader.name
    end

    it "should not include children of excluded models if the depth is set to 2" do
      @word_cloud_output.should_not include @reader.name
    end
  end

  describe "depth" do
    before(:each) do
      @publisher = Publisher.make(:name => "Cloudhouse")
      @author = Author.make(:publisher => @publisher, :name => "Jeremiah Hemphill")
      @article = Article.make(:author => @author)
      @reader = Reader.make(:name => "Alfredo Uribe")
      @article_reader = ArticleReader.make(:article => @article, :reader => @reader)
    end

    it "should return a single level of associations if the depth is set to 1" do
      @word_cloud_output = @article_reader.word_cloud(:array)

      expected_word_cloud_output = [ @article.title, @reader.name ]
      expected_word_cloud_output.each { |str| @word_cloud_output.should include str }

      unexpected_word_cloud_output = [ @publisher.name, @author.name ]
      unexpected_word_cloud_output.each { |str| @word_cloud_output.should_not include str }
      
    end

    it "should return multiple levels of associations if the depth is set to 2" do
      @word_cloud_output = @article.word_cloud(:array)

      expected_word_cloud_output = [
        @author.name,
        @publisher.name,
      ]
      expected_word_cloud_output.each do |str|
        @word_cloud_output.should include str
      end
    end
  end
end
