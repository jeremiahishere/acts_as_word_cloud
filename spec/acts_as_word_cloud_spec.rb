require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "ActsAsWordCloud" do
  before(:each) do
    @article = Article.new
  end

  describe "word_cloud" do
    before(:each) do
      @article.stub(:recursive_word_cloud).and_return([])
    end

    it "should call recursive_word_cloud" do
      @article.should_receive(:recursive_word_cloud).and_return([])
      @article.word_cloud
    end

    it "should return a string by default" do
      @article.word_cloud.should be_a_kind_of String
    end

    it "should return a string if :string is passed as an argument" do
      @article.word_cloud(:string).should be_a_kind_of String
    end

    it "should return an array if :array is passed as an argument" do
      @article.word_cloud(:array).should be_a_kind_of Array
    end
  end

  describe "recursive_word_cloud" do
    before(:each) do
      @article.stub(:word_cloud_get_valid_strings).and_return([])
      @article.stub(:word_cloud_associated_objects).and_return([])
    end
    it "should call word_cloud_get_valid_strings" do
      @article.should_receive(:word_cloud_get_valid_strings).and_return([])
      @article.send(:recursive_word_cloud, 1)
    end

    it "should call word_cloud_associated_objects" do
      @article.should_receive(:word_cloud_associated_objects).and_return([])
      @article.send(:recursive_word_cloud, 1)
    end

    it "should call rescursive_word_cloud on an associated object if the depth is more than 1" do
      object_with_word_cloud = mock(Author)
      object_with_word_cloud.should_receive(:recursive_word_cloud).with(1).and_return([])

      @article.stub(:word_cloud_associated_objects).and_return([object_with_word_cloud])
      @article.send(:recursive_word_cloud, 2)
    end

    it "should call word_cloud_object_name on an associated object if the depth is 1 or less" do
      object_with_word_cloud = mock(Author)
      object_with_word_cloud.stub(:recursive_word_cloud).and_return([])
      @article.stub(:word_cloud_associated_objects).and_return([object_with_word_cloud])

      @article.should_receive(:word_cloud_object_name).with(object_with_word_cloud)
      @article.send(:recursive_word_cloud, 1)
    end

    it "should call word_cloud_object_name on an associated object if the object does not have the word cloud mixin" do
      object_without_word_cloud = mock(Author)
      @article.stub(:word_cloud_associated_objects).and_return([object_without_word_cloud])

      @article.should_receive(:word_cloud_object_name).with(object_without_word_cloud)
      @article.send(:recursive_word_cloud, 2)
    end

    it "should return an array of strings" do
      @article.stub(:word_cloud_get_valid_strings).and_return(["hello"])
      results = @article.send(:recursive_word_cloud, 1)
      results.should be_a_kind_of Array
      results.each { |r| r.should be_a_kind_of String }
    end
  end

  describe "word_cloud_get_valid_strings" do
    before(:each) do
      @article.word_cloud_attributes[:included_methods] = [:sample_method]
      @article.word_cloud_attributes[:excluded_methods] = [:sample_method]
    end

    it "should read the database structure and return text and string fields only" do
      @article.should_receive(:title)
      @article.should_receive(:content)
      @article.should_not_receive(:created_at)
      @article.send(:word_cloud_get_valid_strings)
    end 

    it "should add included methods to the output and call them" do
      @article.word_cloud_attributes[:excluded_methods] = []
      @article.should_receive(:sample_method)
      @article.send(:word_cloud_get_valid_strings)
    end

    it "should remove excluded methods from the output and not call them" do
      @article.should_not_receive(:sample_method)
      @article.send(:word_cloud_get_valid_strings)
    end
  end

  describe "word_cloud_associated_objects" do
    before(:each) do
      @article.stub(:word_cloud_association_names_by_type).and_return([])  
    end
    it "should get objects in belongs to, has ony, and has many relationships" do
      @article.should_receive(:word_cloud_association_names_by_type).with(:belongs_to).and_return([])  
      @article.should_receive(:word_cloud_association_names_by_type).with(:has_one).and_return([])  
      @article.should_receive(:word_cloud_association_names_by_type).with(:has_many).and_return([])  
      @article.send(:word_cloud_associated_objects)
    end

    it "should remove objects that are included in excluded_models" do
      author = Author.new
      @article.stub(:author).and_return(author)
      @article.stub(:word_cloud_association_names_by_type).with(:belongs_to).and_return([:author])
      @article.word_cloud_attributes[:excluded_models] = [Author]
      @article.send(:word_cloud_associated_objects).should be_empty
    end

    it "should return an array of rails models" do
      author = Author.new
      @article.stub(:author).and_return(author)
      @article.stub(:word_cloud_association_names_by_type).with(:belongs_to).and_return([:author])
      @article.word_cloud_attributes[:excluded_models] = []
      @article.send(:word_cloud_associated_objects).should == [author]
    end
  end

  describe "word_cloud_association_names_by_type" do
    # this one is tough to test because we are just calling a single rails method
    it "should return an array of symbols" do
      associations = @article.send(:word_cloud_association_names_by_type, :belongs_to)
      associations.should be_a_kind_of Array
      associations.each { |a| a.should be_a_kind_of Symbol }
    end
  end 

  describe "word_cloud_object_name" do
    it "should use the object's word cloud attribute for object name if set" do
      @article.word_cloud_attributes[:object_name_methods] = [:hello]
      @article.should_receive(:hello).and_return("hello")
      @article.send(:word_cloud_object_name, @article).should == "hello"
    end

    it "should call each member of the method list until it finds one that is runnable on the object" do
      publisher = Publisher.new

      ActsAsWordCloud.config.should_receive(:object_name_methods).and_return([:hello, :world])
      publisher.stub(:respond_to?).with(:word_cloud_attributes).and_return(false)

      publisher.stub(:respond_to?).with(:hello).and_return(false)
      publisher.should_not_receive(:hello)

      publisher.stub(:respond_to?).with(:world).and_return(true)
      publisher.should_receive(:world).and_return("world")

      @article.send(:word_cloud_object_name, publisher).should == "world"
    end

    it "should return an empty string if no methods are found" do
      publisher = Publisher.new

      ActsAsWordCloud.config.should_receive(:object_name_methods).and_return([])
      publisher.stub(:respond_to?).with(:word_cloud_attributes).and_return(false)

      @article.send(:word_cloud_object_name, publisher).should == ""
    end
  end
end
