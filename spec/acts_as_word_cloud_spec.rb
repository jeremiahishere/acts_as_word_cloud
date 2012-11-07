require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "ActsAsWordCloud" do
  before(:each) do
    
    @publisher = nil
    @author = Author.new
    @author.name = "Alfredo Uribe"
    @site = Case::Case.new 
    @site.domain = "articles.com"
    @reader1 = Reader.new
    @reader2 = Reader.new
    @status_label1 = UInterview::StatusLabel.new( name: 'Testing1' )
    @status_label2 = UInterview::StatusLabel.new( name: 'Testing2' )
    @status1 = UDocket::ApprovalStatus.new
    @status2 = UDocket::ApprovalStatus.new
    @status1.stub!(:status_label).and_return(@status_label1) 
    @status2.stub!(:status_label).and_return(@status_label2) 

    @hearing = UDocket::Hearing.new
    @hearing.stub(:worker).and_return(@worker)
    @hearing.stub(:judge).and_return(@judge)
    @hearing.stub(:case).and_return(@case)
    @hearing.stub(:audits).and_return([@audit1, @audit2])
    @hearing.stub(:approval_statuses).and_return([@status1,@status2])
  end
 
  
  describe "word_cloud" do
    describe "class method use_word_cloud" do
      it "should have initialized mixin attributes" do  
        @hearing.should respond_to :word_cloud_using
        @hearing.should respond_to :word_cloud_excluded
        @hearing.should respond_to :word_cloud_depth
      end

      it "should contain default values in attributes" do
        @hearing.word_cloud_using.should include :name
        (@hearing.word_cloud_excluded & [Audit, Denormalizer::MethodOutput, User]).should == [Audit, Denormalizer::MethodOutput, User]
      end
    end

    it "should return the right association models" do
      @hearing.word_cloud.should include @hearing.name
      @hearing.word_cloud.should include @judge.name
      @hearing.word_cloud.should include @case.name
      @hearing.word_cloud.should include @status1.name
      @hearing.word_cloud.should include @status2.name
    end
  end
  
  describe "instance methods:" do
    
    describe "word_cloud_associated_objects" do
      it "should return correct models when called with belongs_to" do
        @hearing.word_cloud_associated_objects(:belongs_to).should include @judge
        @hearing.word_cloud_associated_objects(:belongs_to).should include @case
        @hearing.word_cloud_associated_objects(:belongs_to).should_not include @worker
      end
      
      it "should return correct models when called with has_many" do
        @hearing.word_cloud_associated_objects(:has_many).should include [@audit1,@audit2]
        @hearing.word_cloud_associated_objects(:has_many).should include [@status1,@status2]
      end
    end 
    
    describe "word_cloud_get_associated" do   
      it "should return collectoin of non-nil associated models" do
        @hearing.word_cloud_associated_objects(:belongs_to).should include @judge
        @hearing.word_cloud_associated_objects(:belongs_to).should include @case
        # length here means it's ignoring worker because it's nil
        @hearing.word_cloud_associated_objects(:belongs_to).length.should == 2
      end
    end
 
    describe "word_cloud_exclude_words" do
      it "should not keep excluded models" do
        @hearing.word_cloud_exclude_words([@judge,@case,@audit1,@audit2,@status1,@status2]).should_not include @audit1
        @hearing.word_cloud_exclude_words([@judge,@case,@audit1,@audit2,@status1,@status2]).should_not include @audit2
        @hearing.word_cloud_exclude_words([@judge,@case,@audit1,@audit2,@status1,@status2]).should include @status1
        @hearing.word_cloud_exclude_words([@judge,@case,@audit1,@audit2,@status1,@status2]).should include @status2
        @hearing.word_cloud_exclude_words([@judge,@case,@audit1,@audit2,@status1,@status2]).should include @judge
        @hearing.word_cloud_exclude_words([@judge,@case,@audit1,@audit2,@status1,@status2]).should include @case
      end 
    end
    
    describe "word_cloud_no_mixin" do
      it "should only have models that don't have the mixin" do
        @hearing.word_cloud_no_mixin([@judge,@case,@status1,@status2]).should_not include @judge
        @hearing.word_cloud_no_mixin([@judge,@case,@status1,@status2]).should include @status1
        @hearing.word_cloud_no_mixin([@judge,@case,@status1,@status2]).should include @status2
        @hearing.word_cloud_no_mixin([@judge,@case,@status1,@status2]).should include @case
      end 
    end
     
    describe "word_cloud_process_words" do
      it "should return result of first included method to work on objects with mixin" do
        @hearing.word_cloud_process_words([@judge]).should == ["Dredd"]
      end
    end

    describe "word_cloud_apply_fields_to" do
      it "return the value found in the first method to work on object passed in " do
        @hearing.word_cloud_apply_fields_to(@case).should == "Valid Case Name"
        #I'm using audit here for the sake of the test... I needed a model that wouldn't respond to name
        @hearing.word_cloud_apply_fields_to(@audit1).should == "Audit"
      end
    end

    describe "word_cloud_find_field" do
      it "should return result of first included method to work on objects with mixin" do
        @hearing.word_cloud_find_field([@status1,@status2,@case]).should == ["Testing1","Testing2","Valid Case Name"]
      end
    end
  
  end
end

