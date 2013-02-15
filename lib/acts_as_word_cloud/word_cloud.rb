module ActsAsWordCloud
  module WordCloud
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      # args:
      # using, takes an array of Symbols that refer to the methods we'll use on the model calling word_cloud
      # excluded models, takes in Class names of models we want to ignore that are associated to model calling word_cloud
      # skipped attributes, takes in Symbols referring to attributes that won't be pulled from model calling word_cloud
      # depth level, takes in an Integer referring to how deep of a recursive search we'll make
      # no_mixin_fields, is a default pre-set array of methods to use on models that do not include the mixin
      #
      def acts_as_word_cloud(args)

        # getter/setter methods for the module
        mattr_accessor :word_cloud_using unless respond_to? :word_cloud_using
        mattr_accessor :word_cloud_excluded unless respond_to? :word_cloud_excluded 
        mattr_accessor :word_cloud_skipped unless respond_to? :word_cloud_skipped 
        mattr_accessor :word_cloud_depth unless respond_to? :word_cloud_depth
        mattr_accessor :word_cloud_no_mixin_fields unless respond_to? :word_cloud_no_mixin_fields
                 
        # set empty arrays to allow |= on values          
        unless self.word_cloud_using.is_a?(Array)
          self.word_cloud_using = []      
        end
        unless self.word_cloud_excluded.is_a?(Array)
          self.word_cloud_excluded = []   
        end                      
        unless self.word_cloud_skipped.is_a?(Array)
          self.word_cloud_skipped = []   
        end                      
        unless self.word_cloud_no_mixin_fields.is_a?(Array)
          self.word_cloud_no_mixin_fields = []   
        end                      
              
        # default values if none set in the mixin call on the model
        self.word_cloud_using |= args[:methods_to_use].present? ?  args[:methods_to_use] : []
        self.word_cloud_excluded |= args[:excluded_models].present? ? args[:excluded_models] : []
        self.word_cloud_skipped |= args[:skipped_attributes].present? ? args[:skipped_attributes] : []
        self.word_cloud_depth = args[:depth].present? ? args[:depth] : ActsAsWordCloud.config.min_depth
        self.word_cloud_no_mixin_fields = ActsAsWordCloud.config.no_mixin_fields

        include ActsAsWordCloud::WordCloud::InstanceMethods
      end
    end

    module InstanceMethods
    
      # collects associations on a model as long as they're not nil
      #
      # @param [Symbol] the association type to look in
      # @returns [Array <Symbol>] association names under the passed in type
      #
      def word_cloud_get_associated(type)
        self.class.reflect_on_all_associations(type).select {|r| self.send(r.name).present? }.collect { |r| r.name }
      end
      
      # goes through array of objects or arrays (in the case of has_many association)
      #
      # @param [Symbol] the association type to fetch objects from
      # @returns [Array <Object>] that under association passed in
      #
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
      # @returns [Array <Object>] that are not in the excluded list
      #
      def word_cloud_exclude_words(objects)
        if objects.nil?
          return []
        else
          result = objects.flatten.reject { |x| self.word_cloud_excluded.include?(x.class) }
          return result.present? ? result : []
        end
      end
    
      # removes objects that include word_cloud mixin
      #
      # @returns [Array <Object>] that don't include the mixin
      #
      def word_cloud_no_mixin(objects)
        if objects.nil?
          return []
        else
          result = objects.flatten.reject { |n| n.respond_to?(:word_cloud) }
          result.present? ? result : []
        end
      end
      
      # goes through each object passed in trying the included methods for each of those objects
      # keeps the first one to work and returns the value of that method called on the object
      #
      # @param [Array <Objects>] to look through for values
      # @returns [Array <String>] values returned by method
      #
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
      # @returns [String] value for object passed in 
      #
      def word_cloud_apply_fields_to(no_mixin_model)
        # fields that should be tried on models that don't have the mixin, set with other attributes
        fields = self.word_cloud_no_mixin_fields
        fields.each do |f|
          if no_mixin_model.respond_to?(f)
            return no_mixin_model.send(f)
          end
        end
        return no_mixin_model.class.name
      end
        
      # goes through models that don't include mixin trying to find a relevant value for each
      #
      # @returns [Array <String>] of values for objects passed in
      #
      def word_cloud_find_field(no_mixin)
        output = []
        flag = 0
        no_mixin.each do |n|
          output << word_cloud_apply_fields_to(n) 
        end
        return output
      end
        
      
      # returns values from methods specified in using option
      # ignores string attributes that are listed in the skipped option
      #
      # @returns [Array <String>]
      #
      def word_cloud_get_valid_strings
        output = []
        ignore = []
         
        self.word_cloud_using.each do |m|
          output << self.send(m)
        end
        
        self.word_cloud_skipped.each do |s|
          ignore << self.send(s)
        end

        # current model's string attributes
        output += self.attributes.select {|k,v| v.class == String}.values
        output -= ignore

        return output
      end

      # finds string attributes on model
      # processes associations on model, either fetching word_cloud results if they include mixin or default information if they don't
      # if depth is said to something higher than one the word_cloud results on each associated model then makes more recursive calls (BFS)
      #
      # @returns [Array <String>] all processed values
      #
      def word_cloud( depth = self.word_cloud_depth ) 

        output = []
        objects = []
        no_mixin = []

        output = word_cloud_get_valid_strings
      
        # objects on all associations collected 
        objects += self.word_cloud_associated_objects(:belongs_to)
        objects += self.word_cloud_associated_objects(:has_one)
        objects += self.word_cloud_associated_objects(:has_many) 
        
        # remove objects that have been explicitly excluded on current model
        objects = word_cloud_exclude_words(objects)
        # find associated models that do not include mixin 
        no_mixin = word_cloud_no_mixin(objects)
        objects -= no_mixin
       
        # process object using set methods for each model with mixin, or try preset general methods for models without
        output += self.word_cloud_process_words(objects) + word_cloud_find_field(no_mixin)
       
        # recursive step, if depth > 1, calls word cloud on objects array (which already excludes objects that don't have the mixin)
        if depth < 1
          return "depth for word cloud can't be less than 1"
        elsif depth == 1
          return output.uniq
        else
          output |= objects.collect { |o| o.word_cloud(depth-1) }
          return output.flatten.uniq
        end
      end  
    
    end           
  end
end

