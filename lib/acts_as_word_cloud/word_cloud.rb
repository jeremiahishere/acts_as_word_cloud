module ActsAsWordCloud
  module WordCloud
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      # Sets up the word_cloud method and takes arguments that control what it returns
      # 
      # @param [Hash] args
      # @param args [Array] :included_methods An array of method symbols used to create this model's word cloud
      # @param args [Array] :excluded_methods An array of method symbols used to remove data from the word cloud.  This should be used to remove database fields from the word cloud.
      # @param args [Array] :excluded_models An array of models whose data should not be included in the word cloud
      # @param args [Integer] :depth_level How many levels of associations to include
      # @param args [Symbol] :object_name_method  How to name the object when included in the word cloud as an association
      def acts_as_word_cloud(args = {})

        # getter/setter methods for the module
        mattr_accessor :word_cloud_attributes unless respond_to? :word_cloud_attributes
        allowed_options = [:included_methods, :excluded_methods, :excluded_models, :depth, :object_name_methods]

        # set defaults
        args[:included_methods] ||= []
        args[:excluded_methods] ||= []

        args[:excluded_models] ||= []
        args[:excluded_models] |= ::ActsAsWordCloud.config.permanently_excluded_models

        args[:depth] ||= ::ActsAsWordCloud.config.default_search_depth
        # note that the user passes in object_name_method and it is turned into the array object_name_methods
        args[:object_name_methods] = args[:object_name_method] ? [args[:object_name_method]] : ::ActsAsWordCloud.config.object_name_methods

        self.word_cloud_attributes = args.keep_if { |key| allowed_options.include?(key) }

        include ActsAsWordCloud::WordCloud::InstanceMethods
      end
    end

    module InstanceMethods
      # Uses recursive word cloud to find text attributes, associations and included methods on the model
      #
      # @param [Symbol] return_type Whether to return an array or string, defaulting to :string
      # @return [Array<String> or String] All processed values
      def word_cloud(return_type = :string)
        output = recursive_word_cloud(self.word_cloud_attributes[:depth]).uniq.flatten
        if return_type == :string
          return output.join(' ')
        else
          return output
        end
      end

      protected 

      # Finds all text attributes, associated objects, and included methods down to a specified depth
      # Avoids running the word cloud on objects that have already been included
      #
      # @param [Integer] depth How many layers of associations to search
      # @param [Array] already_included_objects List of objects of models that have already been included in the word cloud
      # @return [Array] The word cloud for the specified object and depth
      def recursive_word_cloud(depth, already_included_objects = []) 
        # prepare an array of strings to be used as an output
        output = []

        # list of database attributes and selected methods minus a list of excluded methods
        output |= word_cloud_get_valid_strings
      
        # array of objects for every association minus a list of excluded objects
        objects = word_cloud_associated_objects

        # do not search again on self
        already_included_objects << self

        objects.each do |obj|
          if already_included_objects.include?(obj)
            # pass because the data is already in the output
          elsif obj.respond_to?(:recursive_word_cloud) && depth > 1
            # if the object has a word cloud mixin and we can recurse
            output |= obj.recursive_word_cloud(depth - 1, already_included_objects)
          else
            # otherwise get the default name for the object
            output |= [self.word_cloud_object_name(obj)]
          end
        end
        return output
      end  

      # returns values from methods specified in included_methods option
      # ignores string attributes that are listed in the excluded_methods option
      #
      # Note that his uses content_columns to read the database data.
      # At some point, we may want to increase the types that are allowed or use a blacklist instead of a whitelist
      #
      # @return [Array <String>] The database fields and included methods with excluded methods removed
      def word_cloud_get_valid_strings
        # database fields
        string_attributes = self.class.content_columns.collect { |c| c.name.to_sym if c.type == :string || c.type == :text }.compact
        #  included methods
        methods = self.word_cloud_attributes[:included_methods] | string_attributes
        # excluded methods
        methods -= self.word_cloud_attributes[:excluded_methods]

        return methods.map { |m| self.send(m) }
      end

      # Gets a list of objects associated to the calling object
      # Uses rails reflect_on_all_associations methods.  Only pulls from belongs_to, has_one, and has_many for now.
      # Each association should return nil, a single object, or an array of objects
      #
      # @return [Array]  List of models associated to the calling object
      def word_cloud_associated_objects
        objects = []
        # get associations
        [:belongs_to, :has_one, :has_many].each do |association_type|
          word_cloud_association_names_by_type(association_type).each do |association|
            objects << self.send(association)
          end
        end
        objects.flatten!
        # remove excluded associations
        objects = objects.delete_if { |o| self.word_cloud_attributes[:excluded_models].include?(o.class) }
        return objects
      end  
    
      # @return [Array <Symbol>] Collect the names of associations of a specific typeI
      def word_cloud_association_names_by_type(type)
        self.class.reflect_on_all_associations(type).collect(&:name)
      end
      
      # Name an object that is included in the word cloud
      # 
      # When the depth level is low or an included gem does not use the word cloud mixin
      # use a special rule to determine the name of the object.  The word cloud attribute
      # object_name_methods is used for objects that use the word cloud.  Otherwise, the
      # default config option is used.  If none of the methods are found on the object, an
      # empty string is returned.
      #
      # @param [ActiveRecord::Base] object The object to name
      # @param [String] The name of the object or a blank string
      def word_cloud_object_name(object)
        output = ""
        method_list = []
        if object.respond_to?(:word_cloud_attributes)
          method_list = object.word_cloud_attributes[:object_name_methods]
        else
          method_list = ::ActsAsWordCloud.config.object_name_methods
        end
        method_list.each do |method|
          if object.respond_to?(method)
            output = object.send(method)
            break
          end
        end
        return output
      end
    end           
  end
end
