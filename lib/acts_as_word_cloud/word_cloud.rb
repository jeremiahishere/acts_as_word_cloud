module ActsAsWordCloud
  module WordCloud
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      # args:
      # methods to use
      # excluded models
      # depth level
      def acts_as_word_cloud(args)

        mattr_accessor :word_cloud_using unless respond_to? :word_cloud_using
        mattr_accessor :word_cloud_excluded unless respond_to? :word_cloud_excluded 
        mattr_accessor :word_cloud_depth unless respond_to? :word_cloud_depth
                  
        unless self.word_cloud_using.is_a?(Array)
          self.word_cloud_using = []      
        end
        unless self.word_cloud_excluded.is_a?(Array)
          self.word_cloud_excluded = []   
        end                      
              
        self.word_cloud_using |= args[:methods_to_use].present? ?  args[:methods_to_use] : [:name] 
        self.word_cloud_excluded |= args[:excluded_models].present? ? args[:excluded_models] : []
        self.word_cloud_depth = args[:depth].present? ? args[:depth] : 1

        include ActsAsWordCloud::WordCloud::InstanceMethods
      end
    end

    module InstanceMethods
    
      # collects associations on a model as long as they're not nil
      #
      # @returns [Array <Symbol>]
      def word_cloud_get_associated(type)
        self.class.reflect_on_all_associations(type).select {|r| self.send(r.name).present? }.collect { |r| r.name }
      end
      
      # goes through array of objects or arrays (in the case of has_many association)
      # and adds each one to an array of objects
      #
      # returns [Array <Object>]
      def word_cloud_associated_objects(type)
        objects = []
        associated = word_cloud_get_associated(type)
        associated.each do |o|
          if o.class == Array
            nested_array = self.send(o)
            nested_array.each do |a|
              objects << a
            end
          else
            objects << self.send(o)
          end
        end
        return objects
      end  
    
      # removes objects that are in the list of objects to exclude
      #
      # @returns [Array <Object>]
      def word_cloud_exclude_words(objects)
        objects.flatten.reject! { |x| self.word_cloud_excluded.include?(x.class) }
      end
    
      # removes objects that include word_cloud mixin
      #
      # @returns [Array <Object>]
      def word_cloud_no_mixin(objects)
        objects.flatten.reject! { |n| n.respond_to?(:word_cloud) }
      end
      
      # goes through each object passed in trying the included methods
      # keeps the first one to work and returns the value of that method called on the object
      #
      # @returns [Array <String>]
      def word_cloud_process_words(objects)
        output = []
        objects.each do |obj|
          obj_calls = obj.word_cloud_using.select { |f| obj.respond_to?(f) }
          if obj_calls.first.present?
            output << obj.send(obj_calls.first)
          end
        end
        return output
      end
        
      # goes through each of the default fields to call on models that don't include mixin
      # and attempts to return the value of the first one to work, if none do return model class name
      #
      # @returns [String]
      def word_cloud_apply_fields_to(no_mixin_model)
        fields = [:name, :title, :work_mail]
        fields.each do |f|
          if no_mixin_model.respond_to?(f)
            return no_mixin_model.send(f)
          end
        end
        return no_mixin_model.class.name
      end
        
      # goes through models that don't include mixin trying to find a relevant value for each
      #
      # @returns [Array <String>]
      def word_cloud_find_field(no_mixin)
        output = []
        flag = 0
        no_mixin.each do |n|
          output << word_cloud_apply_fields_to(n) 
        end
        return output
      end
        
      # finds string attributes on model
      # processes associations on model, either fetching word_cloud results if they include mixin or default information if they don't
      # if depth is said to something higher than one the word_cloud results on each associated model then makes more recursive calls (BFS)
      #
      # @returns [Array <String>]
      def word_cloud( depth = self.word_cloud_depth ) 

        output = []
        objects = []
        no_mixin = []

        self.word_cloud_using.each do |m|
          output << self.send(m)
        end
        output += self.attributes.keep_if {|k,v| v.class == String}.values
       
        objects += self.word_cloud_associated_objects(:belongs_to)
        objects += self.word_cloud_associated_objects(:has_one)
        objects += self.word_cloud_associated_objects(:has_many) 

        objects = word_cloud_exclude_words(objects)
        no_mixin = word_cloud_no_mixin(objects)
        objects -= no_mixin
        
        output += self.word_cloud_process_words(objects) + word_cloud_find_field(no_mixin)
       
        if depth == 1
          return output
        else
          output |= objects.collect { |o| o.word_cloud(depth-1) }
          return output.flatten
        end
      end  
    
    end           
  end
end

